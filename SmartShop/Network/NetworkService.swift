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
    var products: [Product] { get }
}

final class NetworkService {
    private enum ConstantsURLComponents {
        static let scheme = "https"
        static let host = "api.escuelajs.co"
        static let path = "/api/v1/products"
    }
    
    private let decoder = JSONDecoder()
    private let session: URLSession
    
    var products: [Product] = []
    
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
        guard let url = buildURL(queryItems: nil) else { return }
        
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
}
