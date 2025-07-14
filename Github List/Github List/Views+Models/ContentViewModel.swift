//
//  ContentViewModel.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import Foundation

@MainActor
@Observable
final class ContentViewModel {
    private let githubService: GithubServiceProtocol
    
    private(set) var state: LoadingState<[UserModel]> = .loaded([])
    private var currentQuery: String = ""
    private var currentPage: Int = 1
    
    let shouldLoadNextPage: Bool
    
    init(githubService: GithubServiceProtocol = GithubService()) {
        self.githubService = githubService
        self.shouldLoadNextPage = true
    }
    
    // Alternative initializer for testing/previews
    init(githubService: GithubServiceProtocol = MockGithubService(),
         initialState: LoadingState<[UserModel]>,
         shouldLoadNextPage: Bool = false) {
        self.githubService = githubService
        self.state = initialState
        self.shouldLoadNextPage = shouldLoadNextPage
    }
    
    func searchUsers(query: String) async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            state = .loaded([])
            return
        }
        
        currentQuery = trimmed
        currentPage = 1
        state = .loading
        
        do {
            let users = try await githubService.searchUsers(query: query, page: currentPage).items
            state = .loaded(users)
        } catch {
            state = .error(error)
        }
    }
    
    func loadNextPage() async {
        guard case .loaded(let existingUsers) = state else { return }
        
        currentPage += 1
        
        do {
            let newUsers = try await githubService.searchUsers(query: currentQuery, page: currentPage).items
            let allUsers = existingUsers + newUsers
            state = .loaded(allUsers)
        } catch {
            // Reset page on error
            currentPage -= 1
            state = .error(error)
        }
    }
    
    func onLastUserCellAppear() {
        guard shouldLoadNextPage else { return }

        Task { await loadNextPage() }
    }
}
