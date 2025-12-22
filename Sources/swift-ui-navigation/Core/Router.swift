//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 22/12/25.
//

import Foundation

@MainActor
public final class Router<R: Route>: ObservableObject {
    @Published public var path: [R] = []
    
    public init() {}
    
    public func push(_ route: R) {
        path.append(route)
    }
    
    public func pop() {
        guard let last = path.last else { return }
        path.removeLast()
    }
    
    public func reset(routes: [R] = []) {
        path = routes
    }
    
    public func replace(_ route: R) {
        pop()
        push(route)
    }
    
    public var canGoBack: Bool {
        !path.isEmpty
    }
}
