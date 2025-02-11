//
//  ImageLoaderService.swift
//  SmartShop
//
//  Created by Антон Стафеев on 12.02.2025.
//

import UIKit
import OSLog

protocol ImageLoaderProtocol {
    func fetchImage(with url: URL, completion: @escaping (UIImage) -> Void)
}

final class ImageLoaderService {
    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    private func downloadData(_ url: URL, completion: @escaping (Result <Data, NetworkError>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let data, error == nil else {
                Logger.imageLoader.error("Network error: \(error)")
                return completion(.failure(.badData))
            }
            
            guard let response = response as? HTTPURLResponse else {
                Logger.imageLoader.error("Invalid response")
                return completion(.failure(.badResponse))
            }
            
            self?.handleResponse(response, data: data, completion: completion)
        }
        
        task.resume()
    }
    
    private func handleResponse(_ response: HTTPURLResponse, data: Data, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        switch response.statusCode {
        case 200..<300:
            completion(.success(data))
        case 404:
            Logger.imageLoader.error("Resource not found at URL: \(response.url?.absoluteString ?? "Unknown URL")")
            completion(.failure(.notFound))
        case 500:
            Logger.imageLoader.error("Server error for URL: \(response.url?.absoluteString ?? "Unknown URL")")
            completion(.failure(.serverError))
        default:
            Logger.imageLoader.error("Received unexpected status code \(response.statusCode) for URL: \(response.url?.absoluteString ?? "Unknown URL")")
            completion(.failure(.unknownStatusCode(response.statusCode)))
        }
    }
}

// MARK: - ImageLoaderProtocol
extension ImageLoaderService: ImageLoaderProtocol {
    func fetchImage(with url: URL, completion: @escaping (UIImage) -> Void) {
        downloadData(url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else { return }
                    completion(image)
                case .failure(let failure):
                    Logger.imageLoader.error("Error loading product image from \(url): \(failure.localizedDescription)")
                }
            }
        }
    }
}
