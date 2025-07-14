//
//  GithubListTests.swift
//  GithubListTests
//
//  Created by Michael on 7/14/25.
//

import XCTest
@testable import Github_List

final class GithubListTests: XCTestCase {
    var githubService = MockGithubService()

    func testSearch() throws {
        Task {
            let users = try await githubService.searchUsers(query: "mpollock", page: 1)
            XCTAssertEqual(users.items.count, 1)
        }
    }
}
