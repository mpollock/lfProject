//
//  MockGithubService.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import Foundation

struct MockGithubService: GithubServiceProtocol {
    var searchUsersResult: Result<SearchUserModel, Error>
    var getUserResult: Result<UserDetailsModel, Error>
    
    init(searchUsersResult: Result<SearchUserModel, Error> = .failure(NSError()),
         getUserResult: Result<UserDetailsModel, Error> = .failure(NSError())) {
        self.searchUsersResult = searchUsersResult
        self.getUserResult = getUserResult
    }

    func searchUsers(query: String, page: Int) async throws -> SearchUserModel {
        try searchUsersResult.get()
    }

    func getUser(username: String) async throws -> UserDetailsModel {
        try getUserResult.get()
    }
}
