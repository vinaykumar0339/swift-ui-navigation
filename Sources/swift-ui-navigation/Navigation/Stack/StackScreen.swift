//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 24/12/25.
//

import Foundation
import SwiftUI

@MainActor
public struct StackScreen<Routes: Route> {
    
    let route: Routes
    let optionsProvider: ScreenOptionsProvider<Routes>?
    let build: (Navigation<Routes>, any Route) -> AnyView
    
    public init<Content: View>(
        _ route: Routes,
        @ViewBuilder content: @escaping (Navigation<Routes>, any Route) -> Content
    ) {
        self.route = route
        self.optionsProvider = nil
        self.build = { navigation, route in
            AnyView(content(navigation, route))
        }
    }
    
    public init<Content: View>(
        _ route: Routes,
        _ options: ScreenOptions? = nil,
        @ViewBuilder content: @escaping (Navigation<Routes>, any Route) -> Content
    ) {
        self.route = route
        self.optionsProvider = options.map({ .constant($0) })
        self.build = { navigation, route in
            AnyView(content(navigation, route))
        }
    }
    
    public init<Content: View>(
        _ route: Routes,
        _ options: ((Navigation<Routes>, Routes) -> ScreenOptions?)? = nil,
        @ViewBuilder content: @escaping (Navigation<Routes>, any Route) -> Content
    ) {
        self.route = route
        self.optionsProvider = options.map({ .dynamic($0) })
        self.build = { navigation, route in
            AnyView(content(navigation, route))
        }
    }
    
    func getOptions(_ navigation: Navigation<Routes>) -> ScreenOptions? {
        optionsProvider?.resolve(navigation: navigation, route)
    }
}
