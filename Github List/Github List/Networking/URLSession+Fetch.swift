//
//  URLSession+Fetch.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import Foundation

extension URLSession {
    func fetch<T: Codable>(
        _ type: T.Type,
        for request: URLRequest,
        decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
    ) async throws -> T {
        let (data, response) = try await data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            if httpResponse.statusCode == 401 {
                throw NetworkError.unauthorized
            } else {
                throw NetworkError.requestFailed(httpResponse.statusCode)
            }
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.invalidResponse
        }
    }
}
