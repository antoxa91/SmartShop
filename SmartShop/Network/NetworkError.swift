//
//  NetworkError.swift
//  SmartShop
//
//  Created by Антон Стафеев on 12.02.2025.
//

import Foundation

enum NetworkError: Error {
    case badData
    case badResponse
    case badRequest
    case notFound
    case serverError
    case badDecode
    case invalidURL
    case unknownStatusCode(Int)
    
    var localizedDescription: String {
        switch self {
        case .badData:
            return "Received invalid data from the server."
        case .badResponse:
            return "Received an invalid HTTP response."
        case .badRequest:
            return "The request was malformed or invalid."
        case .notFound:
            return "The requested resource was not found."
        case .serverError:
            return "The server encountered an error."
        case .badDecode:
            return "Failed to decode the response data."
        case .invalidURL:
            return "The provided URL is invalid."
        case .unknownStatusCode(let statusCode):
            return "Received an unexpected status code: \(statusCode)."
        }
    }
}
