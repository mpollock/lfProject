//
//  UserDetailsView.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import SwiftUI

struct UserDetailsView: View {
    @State private var viewModel: UserDetailsViewModel
    
    init(viewModel: UserDetailsViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        switch viewModel.state {
        case .loading:
            HStack {
                Text("Loading")
                ProgressView()
            }
            .onAppear {
                viewModel.onAppear()
            }
        case .loaded(let user):
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        PreviewableAsyncImage(url: user.avatarUrl) { image in
                            image
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                                .frame(width: 50, height: 50)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name ?? user.login)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("@\(user.login)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            if let location = user.location {
                                Label(location, systemImage: "location")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    if let bio = user.bio {
                        Text(bio)
                            .font(.body)
                    }
                    
                    HStack(spacing: 30) {
                        StatView(title: "Followers", value: user.followers)
                        StatView(title: "Following", value: user.following)
                        StatView(title: "Repos", value: user.publicRepos)
                    }
                }
                .padding()
            }
            .navigationTitle(user.login)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Link(destination: user.htmlUrl) {
                        Image(systemName: "safari")
                    }
                }
            }
        case .error(let error):
            VStack {
                Text("Error \(error.localizedDescription)")
                Button("Try Again") {
                    Task {
                        await viewModel.getUser()
                    }
                }
            }
        }
    }
}

private struct StatView: View {
    let title: String
    let value: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title2)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Previews
#Preview("Loading State") {
    NavigationStack {
        UserDetailsView(
            viewModel: UserDetailsViewModel(
                username: "mpollock",
                initialState: .loading
            )
        )
    }
}

#Preview("Loaded State") {
    NavigationStack {
        UserDetailsView(
            viewModel: UserDetailsViewModel(
                username: "mpollock",
                initialState: .loaded(UserDetailsModel.Mock.user)
            )
        )
    }
}

#Preview("Error State") {
    NavigationStack {
        UserDetailsView(
            viewModel: UserDetailsViewModel(
                username: "mpollock",
                initialState: .error(NetworkError.unauthorized)
            )
        )
    }
}
