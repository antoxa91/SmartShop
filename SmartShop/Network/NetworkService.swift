//
//  NetworkService.swift
//  SmartShop
//
//  Created by Антон Стафеев on 12.02.2025.
//

import Foundation
import OSLog

protocol ProductsLoader: AnyObject {
    func fetchInitialProducts(completion: @escaping () -> Void)
    func fetchAdditionalProducts(completion: @escaping ([IndexPath]) -> Void)
    func filterByTitle(_ title: String?, completion: @escaping ([Product]) -> Void)
    func filterByParameters(_ parameters: FilterParameters?, completion: @escaping ([Product]) -> Void)
    var products: [Product] { get }
}

final class NetworkService {
    private enum ConstantsURLComponents {
        static let scheme = "https"
        static let host = "api.escuelajs.co"
        static let path = "/api/v1/products"
    }
    
    private enum ConstantsQueryItem {
        static let title = "title"
        static let price = "price"
        static let priceMin = "price_min"
        static let priceMax = "price_max"
        static let categoryId = "categoryId"
        
        static let offset = "offset"
        static let limit = "limit"
    }
    
    private let decoder = JSONDecoder()
    private let session: URLSession
    
    var products: [Product] = []
    private var offset = 0
    private let limit = 8
    private var isLoadingMoreProducts = false

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    private func buildURL(queryItems: [URLQueryItem]?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = ConstantsURLComponents.scheme
        urlComponents.host = ConstantsURLComponents.host
        urlComponents.path = ConstantsURLComponents.path
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
    private func fetchData<T: Decodable>(awaiting type: T.Type, url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data, error == nil else {
                Logger.network.error("Network error: \(error)")
                return completion(.failure(.badData))
            }
            
            guard let response = response as? HTTPURLResponse else {
                Logger.network.error("Invalid response received.")
                return completion(.failure(.badResponse))
            }
            
            switch response.statusCode {
            case 200..<300:
                do {
                    let decodedData = try self.decoder.decode(type.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    Logger.network.error("Decoding error: \(error.localizedDescription)")
                    completion(.failure(.badDecode))
                }
            case 404:
                Logger.network.error("Resource not found at URL: \(response.url?.absoluteString ?? "Unknown URL")")
                completion(.failure(.notFound))
            case 500:
                Logger.network.error("Server error for URL: \(response.url?.absoluteString ?? "Unknown URL")")
                completion(.failure(.serverError))
            default:
                completion(.failure(.unknownStatusCode(response.statusCode)))
            }
        }
        
        task.resume()
    }
}

// MARK: - ProductsLoader
extension NetworkService: ProductsLoader {
    func fetchInitialProducts(completion: @escaping () -> Void) {
        offset = 0

        guard let url = buildURL(queryItems: [
            URLQueryItem(name: ConstantsQueryItem.offset, value: "\(offset)"),
            URLQueryItem(name: ConstantsQueryItem.limit, value: "\(limit)")
        ]) else { return }
        
        fetchData(awaiting: [Product].self, url: url) {[weak self] result in
            switch result {
            case .success(let response):
                self?.products = response

                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                Logger.network.error("Error loading products: \(error.localizedDescription)")
                completion()
            }
        }
    }
    
    func fetchAdditionalProducts(completion: @escaping ([IndexPath]) -> Void) {
        guard !isLoadingMoreProducts else { return }
        isLoadingMoreProducts = true
        
        guard let url = buildURL(queryItems: [
            URLQueryItem(name: ConstantsQueryItem.offset, value: "\(offset)"),
            URLQueryItem(name: ConstantsQueryItem.limit, value: "\(limit)")
        ]) else { return }
        
        fetchData(awaiting: [Product].self, url: url) {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                let moreResults = response
                
                let newCount = moreResults.count
                let totalCount = self.products.count + newCount
                let startingIndex = totalCount - newCount
                let indexPathsToAdd = (startingIndex..<startingIndex + moreResults.count).map {
                    IndexPath(row: $0, section: 0)
                }
                
                self.products.append(contentsOf: moreResults)
                self.offset += self.limit

                self.isLoadingMoreProducts = false
                DispatchQueue.main.async {
                    completion(indexPathsToAdd)
                }
            case .failure(let error):
                self.isLoadingMoreProducts = false
                Logger.network.error("Cant`t download more products: \(error.localizedDescription)")
                completion([])
            }
        }
    }
    
    // MARK: Filters
    func filterByTitle(_ title: String?, completion: @escaping ([Product]) -> Void) {
        let queryItems = [
            URLQueryItem(name: ConstantsQueryItem.title, value: title)
        ]
        filterProducts(with: queryItems, completion: completion)
    }
    
    func filterByParameters(_ parameters: FilterParameters?, completion: @escaping ([Product]) -> Void) {
        let queryItems = [
            URLQueryItem(name: ConstantsQueryItem.price, value: parameters?.price),
            URLQueryItem(name: ConstantsQueryItem.priceMin, value: parameters?.priceMin),
            URLQueryItem(name: ConstantsQueryItem.priceMax, value: parameters?.priceMax),
            URLQueryItem(name: ConstantsQueryItem.categoryId, value: parameters?.categoryId)
        ]
        
        filterProducts(with: queryItems, completion: completion)
    }
    
    private func filterProducts(with queryItems: [URLQueryItem], completion: @escaping ([Product]) -> Void) {
        guard let url = buildURL(queryItems: queryItems) else {
            Logger.network.error("Failed to build URL for filtering with query items: \(queryItems)")
            completion([])
            return
        }

        fetchData(awaiting: [Product].self, url: url) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    completion(response)
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    completion([])
                }
                Logger.network.error("I can’t download the list of filtered products: \(failure.localizedDescription)")
            }
        }
    }
}
