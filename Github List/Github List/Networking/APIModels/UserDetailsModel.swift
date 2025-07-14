//
//  UserDetailsModel.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import Foundation

struct UserDetailsModel: Codable, Identifiable, Equatable {
    var id: String {
        login
    }
    let login: String
    let htmlUrl: URL
    let avatarUrl: URL?
    let name: String?
    let location: String?
    let bio: String?
    let publicRepos: Int
    let followers: Int
    let following: Int
    
    struct Mock {
        static let user = UserDetailsModel(login: "mpollock",
                                           htmlUrl: URL(string: "https://github.com/mpollock/")!,
                                           avatarUrl: nil,
                                           name: "Michael Pollock",
                                           location: "Durham, NC",
                                           bio: "Software Engineer excited to build things for Livefront. Wants to test what happens when putting long text here. Blah blah blah blah blah. Lorem ipsuem, etcetera",
                                           publicRepos: 10,
                                           followers: 100,
                                           following: 999)
    }
}
