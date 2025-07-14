//
//  GithubService.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import Foundation

struct GithubService {
    private let baseURL = "https://api.github.com"
    private let session: URLSession
    private let apiToken: String
    
    var shouldUseMockData = false
    
    // This is how I'd handle the API token for development - in production we'd likely use the keychain or some other solution
    init(session: URLSession = .shared) {
        guard let token = ProcessInfo.processInfo.environment["GITHUB_TOKEN"] else {
            fatalError("GITHUB_TOKEN environment variable not set")
        }
        self.apiToken = token
        self.session = session
    }
    
    func searchUsers(query: String, page: Int = 1) async throws -> SearchUserModel {
        if shouldUseMockData {
            return SearchUserModel.Mock.result
        }
        
        guard let url = buildURL(path: "/search/users", queryItems: [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "page", value: String(page))
        ]) else {
            throw NetworkError.invalidURL
        }
        
        let request = buildRequest(for: url)
        return try await session.fetch(SearchUserModel.self, for: request)
    }
    
    func getUser(username: String) async throws -> UserModel {
        if shouldUseMockData {
            return UserModel.Mock.user
        }
        
        guard let url = buildURL(path: "/users/\(username)") else {
            throw NetworkError.invalidURL
        }
        
        let request = buildRequest(for: url)
        return try await session.fetch(UserModel.self, for: request)
    }
    
    private func buildURL(path: String, queryItems: [URLQueryItem] = []) -> URL? {
        var components = URLComponents(string: baseURL + path)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        return components?.url
    }
    
    private func buildRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
