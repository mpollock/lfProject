//
//  ContentView.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel: ContentViewModel
    @State private var searchText = ""
    
    init(viewModel: ContentViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .loading:
                HStack {
                    Text("Loading")
                    ProgressView()
                }
            case .loaded(let users):
                if users.isEmpty {
                    Text("No users found!")
                } else {
                    List(users) { user in
                        NavigationLink {
                            UserDetailsView(
                                viewModel: UserDetailsViewModel(
                                    githubService: ProcessInfo.isPreview ? MockGithubService() : GithubService(),
                                    username: user.login
                                )
                            )
                        } label: {
                            UserCellView(viewModel: UserCellViewModel(user: user))
                        }
                        .onAppear {
                            // Don't load next page if we're in a preview
                            if user == users.last {
                                viewModel.onLastUserCellAppear()
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            case .error(let error):
                VStack {
                    Text("Error \(error.localizedDescription)")
                    Button("Try Again") {
                        Task {
                            await viewModel.searchUsers(query: searchText)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationTitle("GitHub Users")
        // searchCompletion of previous searches could be nice
        .searchable(text: $searchText, prompt: "Search users...")
        .onSubmit(of: .search) {
            Task {
                await viewModel.searchUsers(query: searchText)
            }
        }
        .onChange(of: searchText) { _, newValue in
            // Don't search as user types unless starting new search
            if newValue.isEmpty {
                Task {
                    await viewModel.searchUsers(query: "")
                }
            }
        }
    }
}

// MARK: - Previews
#Preview("Loading State") {
    ContentView(viewModel: ContentViewModel(initialState: .loading))
}

#Preview("Loaded State") {
    ContentView(viewModel: ContentViewModel(initialState: .loaded([UserModel.Mock.user])))
}

#Preview("No Users State") {
    ContentView(viewModel: ContentViewModel(initialState: .loaded([])))
}

#Preview("Error State") {
    ContentView(viewModel: ContentViewModel(initialState: .error(NetworkError.unauthorized)))
}
