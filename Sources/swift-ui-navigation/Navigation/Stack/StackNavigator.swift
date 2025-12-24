//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 24/12/25.
//

import Foundation
import SwiftUI

@MainActor
public func createStackNavigator<Routes: Route>(
    _ routes: Routes.Type
) -> StackNavigatorFactory<Routes> {
    return StackNavigatorFactory<Routes>()
}

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

@MainActor
public struct StackNavigator<Routes: Route>: View {
    
    @EnvironmentObject var navigation: AnyNavigation
    @AppNavigation<Routes> private var appNavigation
    
    let initialRoute: Routes
    let screenOptions: ScreenOptions?
    let screens: [StackScreen<Routes>]
    
    public var body: some View {
        NavigationStack(path: $navigation.routes) {
            renderScreen(for: initialRoute)
                .navigationDestination(for: AnyRoute.self) { route in
                    renderScreen(for: route)
                }
        }
    }
    
    @ViewBuilder
    private func renderScreen(for route: any Route) -> some View {
        // Make sure route name are unique. Write this in the Documentation
        if let screen = screens.first(where: { $0.route.name == route.name }) {
            let options = screen.options ?? screenOptions // TODO: Will use to add later things like title etc.
            
            screen.build(appNavigation, route)
                .navigationTitle(options?.title ?? screen.route.name)
                .navigationBarTitleDisplayMode(.large)
                
        } else {
            Text("Screen '\(String(describing: route))' not found")
                .foregroundStyle(.red)
        }
    }
}

@MainActor
public struct StackNavigatorFactory<Routes: Route> {
    
    public func Screen(
        route: Routes,
        options: ScreenOptions? = nil,
        @ViewBuilder content: @escaping (Navigation<Routes>, any Route) -> some View
    ) -> StackScreen<Routes> {
        StackScreen(route, options, content: content)
    }
    
    public func Navigator(
        initialRoute: Routes,
        screenOptions: ScreenOptions? = nil,
        @StackBuilder content: () -> [StackScreen<Routes>]
    ) -> StackNavigator<Routes> {
        StackNavigator(initialRoute: initialRoute, screenOptions: screenOptions, screens: content())
    }
    
}

