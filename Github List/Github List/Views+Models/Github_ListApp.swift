//
//  Github_ListApp.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import SwiftUI

@main
struct Github_ListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel())
        }
    }
}
