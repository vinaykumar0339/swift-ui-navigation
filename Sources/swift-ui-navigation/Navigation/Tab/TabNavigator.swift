//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 26/12/25.
//

import Foundation
import SwiftUI

@MainActor
public struct TabNavigator<Routes: Route>: View {
    
    @StateObject private var anyTabNavigation: AnyTabNavigation
    private var tabNavigation: TabNavigation<Routes>
    
    // get current local navigation. to set the parent child relationship
    @Environment(\.navigation) var navigation
    @StateObject private var localNavigation: Navigation
    
    var initialRoute: Routes
    var tabOptionsProvider: TabOptionsProvider<Routes>?
    var tabScreens: [TabScreen<Routes>]
    
    init(
        initialRoute: Routes,
        tabScreens: [TabScreen<Routes>]
    ) {
        
        let anyTabNavigation = AnyTabNavigation(selectedRoute: AnyRoute(initialRoute))
        _anyTabNavigation = StateObject(wrappedValue: anyTabNavigation)
        
        self.tabNavigation = TabNavigation(anyTabNavigation)
        
        let localNavigation = Navigation(navigator: self.tabNavigation)
        _localNavigation = StateObject(wrappedValue: localNavigation)
        
        self.initialRoute = initialRoute
        self.tabOptionsProvider = nil
        self.tabScreens = tabScreens
    }
    
    init(
        initialRoute: Routes,
        tabOptions: TabOptions? = nil,
        tabScreens: [TabScreen<Routes>]
    ) {
        
        let anyTabNavigation = AnyTabNavigation(selectedRoute: AnyRoute(initialRoute))
        _anyTabNavigation = StateObject(wrappedValue: anyTabNavigation)
        
        self.tabNavigation = TabNavigation(anyTabNavigation)
        
        let localNavigation = Navigation(navigator: self.tabNavigation)
        _localNavigation = StateObject(wrappedValue: localNavigation)
        
        self.initialRoute = initialRoute
        self.tabOptionsProvider = tabOptions.map({.constant($0)})
        self.tabScreens = tabScreens
    }
    
    init(
        initialRoute: Routes,
        tabOptions: ((TabNavigation<Routes>, Routes, _ isRouteSelected: Bool) -> TabOptions?)? = nil,
        tabScreens: [TabScreen<Routes>]
    ) {
        
        let anyTabNavigation = AnyTabNavigation(selectedRoute: AnyRoute(initialRoute))
        _anyTabNavigation = StateObject(wrappedValue: anyTabNavigation)
        
        self.tabNavigation = TabNavigation(anyTabNavigation)
        
        let localNavigation = Navigation(navigator: self.tabNavigation)
        _localNavigation = StateObject(wrappedValue: localNavigation)
        
        self.initialRoute = initialRoute
        self.tabOptionsProvider = tabOptions.map({.dynamic($0)})
        self.tabScreens = tabScreens
    }
    
    private func getTabOptions(_ route: Routes, _ isRouteSelected: Bool) -> TabOptions? {
        guard let provider = tabOptionsProvider else { return nil }
        switch provider {
        case .constant(let tabOptions):
            return tabOptions
        case .dynamic(let closure):
            return closure(tabNavigation, route, isRouteSelected)
        }
    }
    
    public var body: some View {
        TabView(selection: $anyTabNavigation.selectedRoute) {
            ForEach(Array(tabScreens.enumerated()), id: \.offset) { _, tab in
                let isRouteSelected = tab.route.name == anyTabNavigation.selectedRoute?.name
                TabScreenView(
                    tabScreen: tab,
                    tabOptions: getTabOptions(tab.route, isRouteSelected),
                    tabNavigation: tabNavigation,
                    isRouteSelected: isRouteSelected
                )
            }
        }
        .onAppear {
            // TODO: Check this can be moved to init, as environment variable can't be accessed in the init
            localNavigation.setParent(navigation)
        }
        .environment(\.navigation, localNavigation)
        .environmentObject(anyTabNavigation)
    }
    
    
}
