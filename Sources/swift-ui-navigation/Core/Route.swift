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
public struct AnyRoute: Route, CustomStringConvertible {
    
    public let name: RouteName
    public let params: any RouteParams
    
    public init<R: Route>(_ route: R) {
        self.name = route.name
        self.params = route.params
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    public static func == (lhs: AnyRoute, rhs: AnyRoute) -> Bool {
        lhs.name == rhs.name
    }
    
    public var description: String {
        return "Route(name: \(name), params: \(String(describing: params))"
    }
    
}
