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
    public let id: UUID
    public let name: Screen
    private var params: Data?
    
    public init<Params: Codable & Hashable>(
        name: Screen,
        params: Params
    ) {
        self.id = UUID()
        self.name = name
        self.params = try? JSONEncoder().encode(params)
    }
    
    public func getParams<Params: Codable>() -> Params? {
        guard let data = params else { return nil }
        return try? JSONDecoder().decode(Params.self, from: data)
    }
    
    mutating func updateParams<Params: Codable & Hashable>(_ params: Params) {
        self.params = try? JSONEncoder().encode(params)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
    
    public static func == (lhs: Route<Screen>, rhs: Route<Screen>) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
    
}

public struct EmptyParams: Codable, Hashable {}

public protocol ScreenProtocol: Hashable, CaseIterable {}
