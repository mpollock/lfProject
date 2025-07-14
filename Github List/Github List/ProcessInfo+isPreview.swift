//
//  ProcessInfo+isPreview.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

import Foundation

extension ProcessInfo {
    static var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
