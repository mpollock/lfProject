//
//  AsyncImagePreviewsView.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import SwiftUI

struct AsyncImagePreviewsView: View {
    var body: some View {
        if ProcessInfo.isPreview {
            // Show local image instead of AsyncImage for preview
            Image(systemName: "person")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
        } else {
        }
    }
}
