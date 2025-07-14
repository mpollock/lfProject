//
//  UserDetailsViewModelTests.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import Foundation
import Testing
@testable import Github_List

@MainActor
@Suite("UserDetailsViewModel Tests")
struct UserDetailsViewModelTests {
    
    let mockUser = UserDetailsModel.Mock.user
    let networkError = NetworkError.unauthorized
    
    // MARK: - getUser() Tests
    
    @Test("getUser() sets loaded state on success")
    func getUserSuccess() async {
        let mock = MockGithubService(getUserResult: .success(mockUser))
        let viewModel = UserDetailsViewModel(
            githubService: mock,
            username: "mpollock",
            initialState: .loading
        )
        
        await viewModel.getUser()
        
        #expect(viewModel.state == .loaded(mockUser))
    }
    
    @Test("getUser() sets error state on failure")
    func getUserFailure() async {
        let mock = MockGithubService(getUserResult: .failure(networkError))
        let viewModel = UserDetailsViewModel(
            githubService: mock,
            username: "mpollock",
            initialState: .loading
        )
        
        await viewModel.getUser()
        
        #expect(viewModel.state == .error(networkError))
    }
    
    // MARK: - onAppear() Tests
    
    @Test("onAppear() triggers load when shouldLoadOnAppear is true")
    func onAppearTriggersLoad() async {
        let mock = MockGithubService(getUserResult: .success(mockUser))
        let viewModel = UserDetailsViewModel(
            githubService: mock,
            username: "mpollock",
            initialState: .loading,
            shouldLoadOnAppear: true
        )
        
        viewModel.onAppear()
        await waitForStateChange { viewModel.state }

        #expect(viewModel.state == .loaded(mockUser))
    }
    
    @Test("onAppear() does nothing when shouldLoadOnAppear is false")
    func onAppearDoesNothing() {
        let mock = MockGithubService()
        let viewModel = UserDetailsViewModel(
            githubService: mock,
            username: "mpollock",
            initialState: .loading,
            shouldLoadOnAppear: false
        )
        
        viewModel.onAppear()
        
        #expect(viewModel.state == .loading)
    }
    
    // MARK: - Parameterized Tests
    
    @Test("Different usernames are handled correctly", arguments: [
        "mpollock",
        "johndoe",
        "test-user",
        "user_with_underscores"
    ])
    func differentUsernames(username: String) async {
        let mock = MockGithubService(getUserResult: .success(mockUser))
        let viewModel = UserDetailsViewModel(
            githubService: mock,
            username: username,
            initialState: .loading
        )
        
        await viewModel.getUser()
        
        #expect(viewModel.state == .loaded(mockUser))
    }
    
    // MARK: - State Transition Tests
    
    @Test("State transitions correctly from loaded to error on retry failure")
    func stateTransitionLoadedToError() async {
        let mock = MockGithubService(getUserResult: .failure(networkError))
        let viewModel = UserDetailsViewModel(
            githubService: mock,
            username: "mpollock",
            initialState: .loaded(mockUser)
        )
        
        #expect(viewModel.state == .loaded(mockUser))
        
        await viewModel.getUser()
        #expect(viewModel.state == .error(networkError))
    }
}
