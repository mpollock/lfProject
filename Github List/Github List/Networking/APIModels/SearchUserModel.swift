//
//  SearchUserModel.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import Foundation

struct SearchUserModel: Codable {
    let items: [UserModel]

    struct Mock {
        static var result = SearchUserModel(
            items: [UserModel.Mock.user]
        )
    }
}
