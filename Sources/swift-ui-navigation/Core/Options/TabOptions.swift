//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 27/12/25.
//

import Foundation

public struct TabOptions {
    let tabItem: TabItem?
    
    let tabBarStyle: TabBarStyle?
    
    public init(
        tabItem: TabItem? = nil,
        tabBarStyle: TabBarStyle? = nil
    ) {
        self.tabItem = tabItem
        self.tabBarStyle = tabBarStyle
    }
}

enum TabOptionsProvider<Routes: Route> {
    case constant(TabOptions)
    case dynamic((TabNavigation<Routes>, Routes, _ isRouteSelected: Bool) -> TabOptions?)
    
    func resolve(
        navigation: TabNavigation<Routes>,
        route: Routes,
        _ isRouteSelected: Bool
    ) -> TabOptions? {
        switch self {
        case .constant(let options):
            return options
        case .dynamic(let closure):
            return closure(navigation, route, isRouteSelected)
        }
    }
}


