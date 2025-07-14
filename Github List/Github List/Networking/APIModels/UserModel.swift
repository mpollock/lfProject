//
//  UserModel.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import Foundation

struct UserModel: Codable, Identifiable, Equatable, Hashable {
    var id: String {
        login
    }
    let login: String
    let avatarUrl: URL?
    let name: String?

    struct Mock {
        static let user = UserModel(login: "mpollock", 
                                    avatarUrl: nil,
                                    name: "Michael Pollock")
    }
}
