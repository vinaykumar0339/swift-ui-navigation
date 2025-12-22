//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 22/12/25.
//

import Foundation

public struct Route<
    Screen: ScreenProtocol
>: Hashable {
    public var id: UUID
    public let name: Screen
    private var params: Data?
    private var options: ScreenOptions?
    
    public init<Params: RouteParams>(
        id: UUID = UUID(),
        name: Screen,
        params: Params? = nil,
        options: ScreenOptions? = nil
    ) {
        self.id = id
        self.name = name
        self.params = try? JSONEncoder().encode(params)
        self.options = options
    }
    
    public func getParams<Params: RouteParams>() -> Params? {
        guard let data = params else { return nil }
        return try? JSONDecoder().decode(Params.self, from: data)
    }
    
    mutating func updateParams<Params: RouteParams>(_ params: Params) {
        self.params = try? JSONEncoder().encode(params)
    }
    
    public func getOptions() -> ScreenOptions? {
        options
    }
    
    mutating func updateOptions(_ options: ScreenOptions) {
        self.options = options
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
    
    public static func == (lhs: Route<Screen>, rhs: Route<Screen>) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
    
}

public protocol RouteParams: Codable & Hashable {}

public struct EmptyParams: RouteParams {}

public protocol ScreenProtocol: Hashable, CaseIterable {}
