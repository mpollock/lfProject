//
//  ContentViewModelTests.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import Foundation
import Testing
@testable import Github_List

@MainActor
@Suite("ContentViewModel Tests")
struct ContentViewModelTests {
    
    let mockUsers = [UserModel.Mock.user]
    let networkError = NetworkError.unauthorized
    
    // MARK: - searchUsers() Tests
    
    @Test("searchUsers sets loaded state on success")
    func searchUsersSuccess() async {
        let mock = MockGithubService(searchUsersResult: .success(SearchUserModel.Mock.result))
        let viewModel = ContentViewModel(githubService: mock)
        
        await viewModel.searchUsers(query: "mpollock")
        
        #expect(viewModel.state == .loaded(mockUsers))
    }
    
    @Test("searchUsers sets error state on failure")
    func searchUsersFailure() async {
        let mock = MockGithubService(searchUsersResult: .failure(networkError))
        let viewModel = ContentViewModel(githubService: mock)
        
        await viewModel.searchUsers(query: "mpollock")
        
        #expect(viewModel.state == .error(networkError))
    }
    
    @Test("searchUsers with empty query sets loaded([])")
    func searchUsersEmptyQuery() async {
        let mock = MockGithubService(searchUsersResult: .success(SearchUserModel.Mock.result))
        let viewModel = ContentViewModel(githubService: mock)
        
        await viewModel.searchUsers(query: "   ")
        
        #expect(viewModel.state == .loaded([]))
    }
    
    // MARK: - loadNextPage() Tests
    
    @Test("loadNextPage appends users on success")
    func loadNextPageSuccess() async {
        let firstPageUser = UserModel(login: "first", avatarUrl: nil, name: nil)
        let secondPageUser = UserModel(login: "second", avatarUrl: nil, name: nil)
        
        let mock = MockGithubService(searchUsersResult: .success(SearchUserModel(items: [secondPageUser])))
        let viewModel = ContentViewModel(
            githubService: mock,
            initialState: .loaded([firstPageUser]),
            shouldLoadNextPage: true
        )
        
        await viewModel.loadNextPage()
        
        #expect(viewModel.state == .loaded([firstPageUser, secondPageUser]))
    }
    
    @Test("loadNextPage sets error state on failure")
    func loadNextPageFailure() async {
        let firstPageUser = UserModel(login: "first", avatarUrl: nil, name: nil)
        
        let mock = MockGithubService(searchUsersResult: .failure(networkError))
        let viewModel = ContentViewModel(
            githubService: mock,
            initialState: .loaded([firstPageUser])
        )
        
        await viewModel.loadNextPage()
        
        #expect(viewModel.state == .error(networkError))
    }
    
    // MARK: - onLastUserCellAppear() Tests
    
    @Test("onLastUserCellAppear triggers loadNextPage when shouldLoadNextPage is true")
    func onLastUserCellAppearTriggersLoad() async {
        let firstPageUser = UserModel(login: "first", avatarUrl: nil, name: nil)
        let secondPageUser = UserModel(login: "second", avatarUrl: nil, name: nil)

        let mock = MockGithubService(searchUsersResult: .success(SearchUserModel(items: [secondPageUser])))
        let viewModel = ContentViewModel(
            githubService: mock,
            initialState: .loaded([firstPageUser]),
            shouldLoadNextPage: true
        )
        
        viewModel.onLastUserCellAppear()
        await waitForStateChange { viewModel.state }

        #expect(viewModel.state == .loaded([firstPageUser, secondPageUser]))
    }
    
    @Test("onLastUserCellAppear does nothing when shouldLoadNextPage is false")
    func onLastUserCellAppearDoesNothing() async {
        let mock = MockGithubService(searchUsersResult: .success(SearchUserModel.Mock.result))
        let viewModel = ContentViewModel(
            githubService: mock,
            initialState: .loaded(mockUsers)
        )
        
        viewModel.onLastUserCellAppear()
        
        #expect(viewModel.state == .loaded(mockUsers))
    }
}
