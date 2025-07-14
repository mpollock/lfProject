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
    private let gitHubService: GithubService
    
    private(set) var state: LoadingState<[UserModel]> = .loaded([])
    private var currentQuery: String = ""
    private var currentPage: Int = 1
    
    init(gitHubService: GithubService = GithubService()) {
        self.gitHubService = gitHubService
    }
    
    func searchUsers(query: String) async {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            state = .loaded([])
            return
        }
        
        currentQuery = query
        currentPage = 1
        state = .loading
        
        do {
            let users = try await gitHubService.searchUsers(query: query, page: currentPage).items
            state = .loaded(users)
        } catch {
            state = .error(error)
        }
    }
    
    func loadNextPage() async {
        guard case .loaded(let existingUsers) = state else { return }
        
        currentPage += 1
        
        do {
            let newUsers = try await gitHubService.searchUsers(query: currentQuery, page: currentPage).items
            let allUsers = existingUsers + newUsers
            state = .loaded(allUsers)
        } catch {
            // Reset page on error
            currentPage -= 1
            state = .error(error)
        }
    }
}
