//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 26/12/25.
//

import Foundation
import SwiftUI

@MainActor
public func createTabNavigator<Routes: Route>(
    _ routes: Routes.Type
) -> TabNavigatorFactory<Routes> {
    return TabNavigatorFactory<Routes>()
}

@MainActor
public struct TabNavigatorFactory<Routes: Route> {
    
    public func Screen(
        route: Routes,
        @ViewBuilder content: @escaping (TabNavigation<Routes>, Routes) -> some View
    ) -> TabScreen<Routes> {
        TabScreen(
            route,
            content: content
        )
    }
    
    public func Screen(
        route: Routes,
        options: TabOptions? = nil,
        @ViewBuilder content: @escaping (TabNavigation<Routes>, Routes) -> some View
    ) -> TabScreen<Routes> {
        TabScreen(
            route,
            options,
            content: content
        )
    }
    
    public func Screen(
        route: Routes,
        options: ((TabNavigation<Routes>, Routes, _ isRouteSelected: Bool) -> TabOptions?)? = nil,
        @ViewBuilder content: @escaping (TabNavigation<Routes>, Routes) -> some View
    ) -> TabScreen<Routes> {
        TabScreen(
            route,
            options,
            content: content
        )
    }
    
    public func Navigator(
        initialRoute: Routes,
        @TabBuilder content: () -> [TabScreen<Routes>]
    ) -> TabNavigator<Routes> {
        TabNavigator(
            initialRoute: initialRoute,
            tabScreens: content()
        )
    }
    
    public func Navigator(
        initialRoute: Routes,
        tabOptions: TabOptions? = nil,
        @TabBuilder content: () -> [TabScreen<Routes>]
    ) -> TabNavigator<Routes> {
        TabNavigator(
            initialRoute: initialRoute,
            tabOptions: tabOptions,
            tabScreens: content()
        )
    }
    
    public func Navigator(
        initialRoute: Routes,
        tabOptions: ((TabNavigation<Routes>, Routes, _ isRouteSelected: Bool) -> TabOptions?)? = nil,
        @TabBuilder content: () -> [TabScreen<Routes>]
    ) -> TabNavigator<Routes> {
        TabNavigator(
            initialRoute: initialRoute,
            tabOptions: tabOptions,
            tabScreens: content()
        )
    }
    
}
