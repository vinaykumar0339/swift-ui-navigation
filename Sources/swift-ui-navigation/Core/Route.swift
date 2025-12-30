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
