//
//  PreviewableAsyncImage.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import SwiftUI

// Allows for using AsyncImage in previews with a placeholder image instead of hitting a URL
struct PreviewableAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    let previewImage: Image
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    init(url: URL?,
         previewImage: Image = Image(systemName: "person"),
         @ViewBuilder content: @escaping (Image) -> Content,
         @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.previewImage = previewImage
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        if ProcessInfo.isPreview {
            content(previewImage)
        } else {
            AsyncImage(url: url, content: content, placeholder: placeholder)
        }
    }
}
