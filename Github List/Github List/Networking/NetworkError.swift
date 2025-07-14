//
//  NetworkError.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case requestFailed(Int)
    case unauthorized
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Response"
        case .invalidData:
            return "Invalid Data"
        case .requestFailed(let statusCode):
            return "Request Failed with status code: \(statusCode)"
        case .unauthorized:
            return "Unauthorized"
        }
    }
}
