//
//  UserDetailView.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import SwiftUI

struct UserDetailView: View {
    let user: UserDetailsModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    AsyncImage(url: user.avatarUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.name ?? user.login)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("@\(user.login)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
//                        if let location = user.location {
//                            Label(location, systemImage: "location")
//                                .font(.caption)
//                                .foregroundStyle(.secondary)
//                        }
                    }
                    
                    Spacer()
                }
                
                // Bio
//                if let bio = user.bio {
//                    Text(bio)
//                        .font(.body)
//                }
                
                // Stats
                HStack(spacing: 30) {
//                    StatView(title: "Followers", value: user.followers ?? 0)
//                    StatView(title: "Following", value: user.following ?? 0)
//                    StatView(title: "Repos", value: user.publicRepos ?? 0)
                }
                
                // Links
                VStack(alignment: .leading, spacing: 12) {
//                    if let blog = user.blog, !blog.isEmpty {
//                        Link(destination: URL(string: blog.hasPrefix("http") ? blog : "https://\(blog)") ?? URL(string: "https://github.com")!) {
//                            Label(blog, systemImage: "link")
//                        }
//                    }
                    
//                    if let company = user.company {
//                        Label(company, systemImage: "building.2")
//                    }
                    
//                    if let email = user.email {
//                        Link(destination: URL(string: "mailto:\(email)")!) {
//                            Label(email, systemImage: "envelope")
//                        }
//                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(user.login)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
//                Link(destination: URL(string: user.htmlURL)!) {
//                    Image(systemName: "safari")
//                }
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

#Preview {
    ContentView()
}

#Preview("User Detail") {
    NavigationStack {
        UserDetailView(user: UserModel.Mock.user)
    }
}
