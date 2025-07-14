//
//  Github_ListApp.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import SwiftUI

@main
struct Github_ListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel(githubService: Self.createGithubService()))
        }
    }
    
    static func createGithubService() -> GithubServiceProtocol {
        if ProcessInfo.processInfo.arguments.contains("-UITest_useMockService") {
            return MockGithubService(searchUsersResult: .success(SearchUserModel.Mock.result),
                                     getUserResult: .success(UserDetailsModel.Mock.user))
        } else {
            return GithubService()
        }
    }
}
