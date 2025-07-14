//
//  UserCellView.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import SwiftUI

struct UserCellView: View {
    @StateObject var viewModel: UserCellViewModel

    var body: some View {
        HStack {
            if ProcessInfo.isPreview {
                // Show local image instead of AsyncImage for preview
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                AsyncImage(url: viewModel.user.avatarUrl) { image in
                    image
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(width: 50, height: 50)
                }
            }
            VStack(alignment: .leading) {
                Text(viewModel.user.name ?? viewModel.user.login)
            }
        }
    }
}

#Preview {
    UserCellView(viewModel: UserCellViewModel(user: UserModel.Mock.user))
}
