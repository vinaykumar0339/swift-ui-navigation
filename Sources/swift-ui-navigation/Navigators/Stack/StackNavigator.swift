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

public struct NativeStackNavigator<Screen: ScreenProtocol> {
    
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
        @ViewBuilder component: @escaping (ScreenProps<Screen, EmptyParams>) -> Content
    ) -> ScreenConfiguration<Screen> {
        ScreenConfiguration(
            name: name,
            options: options,
            builder: { route, navigation in
                let props = ScreenProps(navigation: navigation, route: route, params: EmptyParams())
                return AnyView(component(props))
            }
        )
    }
    
    /// Register screen with params
    public func Screen<Content: View, Params: Codable>(
        name: Screen,
        options: ScreenOptions = .default,
        @ViewBuilder component: @escaping (ScreenProps<Screen, Params>) -> Content
    ) -> ScreenConfiguration<Screen> {
        ScreenConfiguration(
            name: name,
            options: options,
            builder: { route, navigation in
                let params: Params = route.getParams() ?? EmptyParams() as! Params
                let props = ScreenProps(navigation: navigation, route: route, params: params)
                return AnyView(component(props))
            }
        )
    }
}
