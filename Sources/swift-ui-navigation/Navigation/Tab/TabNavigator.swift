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
    
    var initialRoute: Routes
    var tabScreens: [TabScreen<Routes>]
    
    init(
        initialRoute: Routes,
        tabScreens: [TabScreen<Routes>]
    ) {
        
        let anyTabNavigation = AnyTabNavigation()
        _anyTabNavigation = StateObject(wrappedValue: anyTabNavigation)
        
        self.tabNavigation = TabNavigation(anyTabNavigation)
        
        self.initialRoute = initialRoute
        self.tabScreens = tabScreens
    }
    
    public var body: some View {
        TabView(selection: $anyTabNavigation.selectedRoute) {
            ForEach(Array(tabScreens.enumerated()), id: \.offset) { _, tab in
                TabScreenView(tabScreen: tab, tabNavigation: tabNavigation)
            }
        }
        .environmentObject(anyTabNavigation)
    }
    
    
}
