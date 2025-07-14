//
//  UserDetailViewModel.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import Foundation

final class UserDetailViewModel: ObservableObject {
    @Published var user: UserDetailsModel

    init(user: UserDetailsModel) {
        self.user = user
    }
}
