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
