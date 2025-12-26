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
        @ViewBuilder content: @escaping (Navigation<Routes>, any Route) -> some View
    ) -> StackScreen<Routes> {
        StackScreen(route, content: content)
    }
    
    public func Screen(
        route: Routes,
        options: ScreenOptions? = nil,
        @ViewBuilder content: @escaping (Navigation<Routes>, any Route) -> some View
    ) -> StackScreen<Routes> {
        StackScreen(route, options, content: content)
    }
    
    public func Screen(
        route: Routes,
        options: ((Navigation<Routes>, Routes) -> ScreenOptions?)? = nil,
        @ViewBuilder content: @escaping (Navigation<Routes>, any Route) -> some View
    ) -> StackScreen<Routes> {
        StackScreen(route, options, content: content)
    }
    
    public func Navigator(
        initialRoute: Routes,
        @StackBuilder content: () -> [StackScreen<Routes>]
    ) -> StackNavigator<Routes> {
        StackNavigator(initialRoute: initialRoute, screens: content())
    }
    
    public func Navigator(
        initialRoute: Routes,
        screenOptions: ScreenOptions? = nil,
        @StackBuilder content: () -> [StackScreen<Routes>]
    ) -> StackNavigator<Routes> {
        StackNavigator(initialRoute: initialRoute, screenOptions: screenOptions, screens: content())
    }
    
    public func Navigator(
        initialRoute: Routes,
        screenOptions: ((Navigation<Routes>, Routes) -> ScreenOptions?)? = nil,
        @StackBuilder content: () -> [StackScreen<Routes>]
    ) -> StackNavigator<Routes> {
        StackNavigator(initialRoute: initialRoute, screenOptions: screenOptions, screens: content())
    }
    
}
