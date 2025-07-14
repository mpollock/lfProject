//
//  UserDetailViewModel.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import Foundation

@MainActor
@Observable
final class UserDetailsViewModel {
    private let githubService: GithubServiceProtocol
    private let username: String

    private(set) var state: LoadingState<UserDetailsModel> = .loading
    
    let shouldLoadOnAppear: Bool

    init(githubService: GithubServiceProtocol, username: String) {
        self.githubService = githubService
        self.username = username
        self.shouldLoadOnAppear = true
    }
    
    // Alternative initializer for testing/previews
    init(githubService: GithubServiceProtocol = MockGithubService(),
         username: String,
         initialState: LoadingState<UserDetailsModel>,
         shouldLoadOnAppear: Bool = false) {
        self.githubService = githubService
        self.username = username
        self.state = initialState
        self.shouldLoadOnAppear = shouldLoadOnAppear
    }
    
    func getUser() async {
        state = .loading
        
        do {
            let user = try await githubService.getUser(username: username)
            state = .loaded(user)
        } catch {
            state = .error(error)
        }
    }
    
    func onAppear() {
        guard shouldLoadOnAppear else { return }
        Task { await getUser() }
    }
}
