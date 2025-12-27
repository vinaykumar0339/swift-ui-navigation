//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 26/12/25.
//

import Foundation
import SwiftUI

@MainActor
public struct TabScreen<Routes: Route> {
    
    let route: Routes
    let optionsProvider: TabOptionsProvider<Routes>?
    let build: (TabNavigation<Routes>, any Route) -> AnyView
    
    public init<Content: View>(
        _ route: Routes,
        @ViewBuilder content: @escaping (TabNavigation<Routes>, any Route) -> Content
    ) {
        self.route = route
        self.optionsProvider = nil
        self.build = { navigator, route in
            AnyView(content(navigator, route))
        }
    }
    
    public init<Content: View>(
        _ route: Routes,
        _ options: TabOptions? = nil,
        @ViewBuilder content: @escaping (TabNavigation<Routes>, any Route) -> Content
    ) {
        self.route = route
        self.optionsProvider = options.map({.constant($0)})
        self.build = { navigator, route in
            AnyView(content(navigator, route))
        }
    }
    
    public init<Content: View>(
        _ route: Routes,
        _ options: ((TabNavigation<Routes>, Routes, _ isRouteSelected: Bool) -> TabOptions?)? = nil,
        @ViewBuilder content: @escaping (TabNavigation<Routes>, any Route) -> Content
    ) {
        self.route = route
        self.optionsProvider = options.map({ .dynamic($0) })
        self.build = { navigator, route in
            AnyView(content(navigator, route))
        }
    }
    
    func getOptions(_ navigation: TabNavigation<Routes>, isRouteSelected: Bool) -> TabOptions? {
        optionsProvider?.resolve(navigation: navigation, route: route, isRouteSelected)
    }
    
}

struct TabScreenView<Routes: Route>: View {
    
    let tabScreen: TabScreen<Routes>
    var tabOptions: TabOptions?
    var tabNavigation: TabNavigation<Routes>
    
    @EnvironmentObject private var anyTabNavigation: AnyTabNavigation
    
    init(
        tabScreen: TabScreen<Routes>,
        tabOptions: TabOptions? = nil,
        tabNavigation: TabNavigation<Routes>,
        isRouteSelected: Bool = false
    ) {
        self.tabScreen = tabScreen
        self.tabOptions = tabScreen.getOptions(tabNavigation, isRouteSelected: isRouteSelected) ?? tabOptions
        self.tabNavigation = tabNavigation
    }
    
    var body: some View {
        
        let tabBarStyle = tabOptions?.tabBarStyle ?? .init(.clear, isVisible: true)
        let hasCustomTabBar = tabOptions?.tabBar != nil
        
        let screenView = tabScreen
            .build(tabNavigation, tabScreen.route)
            .tag(AnyRoute(tabScreen.route))
            .toolbarBackground(tabBarStyle.style, for: .tabBar)
            .toolbarBackground(tabBarStyle.isVisible == true ? .visible : .hidden, for: .tabBar)
        
        if hasCustomTabBar {
            screenView
                .safeAreaInset(edge: .bottom) {
                    if tabBarStyle.isVisible == true {
                        tabOptions?.tabBar?.resolve()
                    }
                }
                .toolbar(.hidden, for: .tabBar) // Hide the default toolBar
        } else {
            screenView.tabItem {
                let tabItem = tabOptions?.tabItem ?? .item(.text(tabScreen.route.name))
                return tabItem.resolve()
            }
        }
        
    }
    
}
