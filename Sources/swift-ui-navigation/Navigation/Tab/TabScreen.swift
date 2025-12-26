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
    let build: (TabNavigation<Routes>, any Route) -> AnyView
    
    public init<Content: View>(
        _ route: Routes,
        @ViewBuilder content: @escaping (TabNavigation<Routes>, any Route) -> Content
    ) {
        self.route = route
        self.build = { navigator, route in
            AnyView(content(navigator, route))
        }
    }
    
}

struct TabScreenView<Routes: Route>: View {
    
    let tabScreen: TabScreen<Routes>
    let tabNavigation: TabNavigation<Routes>
    
    @EnvironmentObject private var anyTabNavigation: AnyTabNavigation
    
    init(
        tabScreen: TabScreen<Routes>,
        tabNavigation: TabNavigation<Routes>
    ) {
        self.tabScreen = tabScreen
        self.tabNavigation = tabNavigation
    }
    
    var body: some View {
        tabScreen
            .build(tabNavigation, tabScreen.route)
            .tag(AnyRoute(tabScreen.route))
            .tabItem {
                Text(tabScreen.route.name)
            }
    }
    
}
