//
//  UserCellView.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import SwiftUI

struct UserCellView: View {
    var viewModel: UserCellViewModel

    var body: some View {
        HStack {
            PreviewableAsyncImage(url: viewModel.user.avatarUrl) { image in
                image
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
                    .frame(width: 50, height: 50)
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
