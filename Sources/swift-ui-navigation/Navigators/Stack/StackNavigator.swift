//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 22/12/25.
//

import Foundation
import SwiftUI

public func createNativeStackNavigator<Screen: ScreenProtocol>(_: Screen.Type) -> NativeStackNavigator<Screen> {
    NativeStackNavigator<Screen>()
}

public struct NativeStackNavigator<
    Screen: ScreenProtocol
> {
    
    @MainActor
    public func Navigator(
        initialRouteName: Screen,
        @ScreenBuilder<Screen> screens: () -> [ScreenConfiguration<Screen>]
    ) -> some View {
        StackNavigatorView(initialRoute: initialRouteName, screens: screens())
    }
    
    /// Register screen without params
    public func Screen<Content: View>(
        name: Screen,
        options: ScreenOptions = .default,
        @ViewBuilder component: @escaping (ScreenProps<Screen>) -> Content
    ) -> ScreenConfiguration<Screen> {
        ScreenConfiguration(
            name: name,
            options: options,
            builder: { route, navigation in
                let props = ScreenProps(navigation: navigation, route: route)
                return AnyView(component(props))
            }
        )
    }
    
    /// Register screen with params
    public func Screen<Content: View, Params: RouteParams>(
        name: Screen,
        options: ScreenOptions = .default,
        params: Params.Type = EmptyParams.self,
        @ViewBuilder component: @escaping (ScreenProps<Screen>) -> Content
    ) -> ScreenConfiguration<Screen> {
        ScreenConfiguration(
            name: name,
            options: options,
            builder: { route, navigation in
                let props = ScreenProps(navigation: navigation, route: route)
                return AnyView(component(props))
            }
        )
    }
}
