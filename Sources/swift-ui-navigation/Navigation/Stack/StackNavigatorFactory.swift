//
//  StackNavigatorFactory.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 26/12/25.
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
public struct StackNavigatorFactory<Routes: Route> {
    
    public func Screen(
        route: Routes,
        @ViewBuilder content: @escaping (StackNavigation<Routes>, Routes) -> some View
    ) -> StackScreen<Routes> {
        StackScreen(route, content: content)
    }
    
    public func Screen(
        route: Routes,
        options: ScreenOptions? = nil,
        @ViewBuilder content: @escaping (StackNavigation<Routes>, Routes) -> some View
    ) -> StackScreen<Routes> {
        StackScreen(route, options, content: content)
    }
    
    public func Screen(
        route: Routes,
        options: ((StackNavigation<Routes>, Routes) -> ScreenOptions?)? = nil,
        @ViewBuilder content: @escaping (StackNavigation<Routes>, Routes) -> some View
    ) -> StackScreen<Routes> {
        StackScreen(route, options, content: content)
    }
    
    public func Navigator(
        initialRoute: Routes,
        @StackBuilder content: () -> [StackScreen<Routes>]
    ) -> StackNavigator<Routes> {
        let screens = content()
        if let initialScreen = screens.filter({ $0.route.name == initialRoute.name }).first ?? screens.first {
            return StackNavigator(initialScreen: initialScreen, screens: content())
        }
        fatalError("Initial route \(initialRoute) not found in provided screens")
    }
    
    public func Navigator(
        initialRoute: Routes,
        screenOptions: ScreenOptions? = nil,
        @StackBuilder content: () -> [StackScreen<Routes>]
    ) -> StackNavigator<Routes> {
        let screens = content()
        if let initialScreen = screens.filter({ $0.route.name == initialRoute.name }).first ?? screens.first {
            return StackNavigator(initialScreen: initialScreen, screens: content())
        }
        fatalError("Initial route \(initialRoute) not found in provided screens")
    }
    
    public func Navigator(
        initialRoute: Routes,
        screenOptions: ((StackNavigation<Routes>, Routes) -> ScreenOptions?)? = nil,
        @StackBuilder content: () -> [StackScreen<Routes>]
    ) -> StackNavigator<Routes> {
        let screens = content()
        if let initialScreen = screens.filter({ $0.route.name == initialRoute.name }).first ?? screens.first {
            return StackNavigator(initialScreen: initialScreen, screens: content())
        }
        fatalError("Initial route \(initialRoute) not found in provided screens")
    }
    
}
