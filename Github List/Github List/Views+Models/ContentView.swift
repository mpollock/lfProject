//
//  ContentView.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ContentViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .loading:
                HStack {
                    Text("Loading")
                    ProgressView()
                }
            case .loaded(let users):
                List(users) { user in
                    UserCellView(viewModel: UserCellViewModel(user: user))
                        .onAppear {
                            if user == users.last {
                                Task {
                                    await viewModel.loadNextPage()
                                }
                            }
                        }
                }
            case .error(let error):
                Text("Error \(error.localizedDescription)")
            }
        }
        // searchCompletion of previous searches could be nice
        .searchable(text: $searchText)
        .onSubmit(of: .search, {
            Task {
                await viewModel.searchUsers(query: searchText)
            }
        })
    }
}

#Preview {
    ContentView()
}
