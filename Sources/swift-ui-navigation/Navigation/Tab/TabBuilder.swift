//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 26/12/25.
//

import Foundation
import SwiftUI

@MainActor
@resultBuilder
public struct TabBuilder {
    
    public static func buildExpression<Routes: Route>(
        _ expression: TabScreen<Routes>
    ) -> [TabScreen<Routes>] {
        [expression]
    }
    
    public static func buildBlock<Routes: Route>(_ components: [TabScreen<Routes>]...) -> [TabScreen<Routes>] {
        components.flatMap({ $0 })
    }
    
    public static func buildOptional<Routes: Route>(
        _ component: [TabScreen<Routes>]?
    ) -> [TabScreen<Routes>] {
        component ?? []
    }

    public static func buildEither<Routes: Route>(
        first component: [TabScreen<Routes>]
    ) -> [TabScreen<Routes>] {
        component
    }

    public static func buildEither<Routes: Route>(
        second component: [TabScreen<Routes>]
    ) -> [TabScreen<Routes>] {
        component
    }

    public static func buildArray<Routes: Route>(
        _ components: [[TabScreen<Routes>]]
    ) -> [TabScreen<Routes>] {
        components.flatMap { $0 }
    }
    
}
