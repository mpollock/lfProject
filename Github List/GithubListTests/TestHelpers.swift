//
//  TestHelpers.swift
//  GithubListTests
//
//  Created by Michael on 7/14/25.
//

import Foundation

/// Waits for a property to change from its initial value.
/// - Parameters:
///   - getState: A function which returns the property you want to observe
///   - timeout: Max time to wait (default 1s)
/// - Returns: True if value changed, false if timeout
@MainActor
func waitForStateChange<T: Equatable>(
    getState: () -> T,
    timeout: TimeInterval = 1.0
) async {
    let startTime = Date()
    let initialValue = getState()

    while getState() == initialValue && Date().timeIntervalSince(startTime) < timeout {
        try? await Task.sleep(for: .milliseconds(10))
    }

    return
}
