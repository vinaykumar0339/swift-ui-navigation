//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 24/12/25.
//

import Foundation

public typealias RouteName = String
public typealias RouteParams = Codable & Hashable

public struct EmptyParams: RouteParams {
    public init() {}
}

public protocol Route: Hashable {
    var name: RouteName { get }
    var params: any RouteParams { get }
}

/// Type-erased Any Route to use this in the Navigation State.
struct AnyRoute: Route, CustomStringConvertible {
    
    let name: RouteName
    let params: any RouteParams
    
    init<R: Route>(_ route: R) {
        self.name = route.name
        self.params = route.params
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: AnyRoute, rhs: AnyRoute) -> Bool {
        lhs.name == rhs.name
    }
    
    var description: String {
        return "Route(name: \(name), params: \(String(describing: params))"
    }
    
}
