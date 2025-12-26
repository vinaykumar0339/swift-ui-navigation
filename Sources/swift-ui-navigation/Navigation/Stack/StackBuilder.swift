//
//  StackBuilder.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 26/12/25.
//


import Foundation
import SwiftUI

@MainActor
@resultBuilder
public struct StackBuilder {
    
    public static func buildExpression<Routes: Route>(
        _ expression: StackScreen<Routes>
    ) -> [StackScreen<Routes>] {
        [expression]
    }

    public static func buildBlock<Routes: Route>(
        _ components: [StackScreen<Routes>]...
    ) -> [StackScreen<Routes>] {
        components.flatMap { $0 }
    }

    public static func buildOptional<Routes: Route>(
        _ component: [StackScreen<Routes>]?
    ) -> [StackScreen<Routes>] {
        component ?? []
    }

    public static func buildEither<Routes: Route>(
        first component: [StackScreen<Routes>]
    ) -> [StackScreen<Routes>] {
        component
    }

    public static func buildEither<Routes: Route>(
        second component: [StackScreen<Routes>]
    ) -> [StackScreen<Routes>] {
        component
    }

    public static func buildArray<Routes: Route>(
        _ components: [[StackScreen<Routes>]]
    ) -> [StackScreen<Routes>] {
        components.flatMap { $0 }
    }
    
}