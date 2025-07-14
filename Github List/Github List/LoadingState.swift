//
//  LoadingState.swift
//  Github List
//
//  Created by Michael on 7/14/25.
//

public enum LoadingState<T> {
    case loading
    case loaded(T)
    case error(Error)
}

extension LoadingState: Equatable where T: Equatable {
    public static func ==(lhs: LoadingState<T>, rhs: LoadingState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.loaded(let a), .loaded(let b)):
            return a == b
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}
