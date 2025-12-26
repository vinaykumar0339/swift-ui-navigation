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
    let options: ScreenOptions?
    let build: (Navigation<Routes>, any Route) -> AnyView
    
    public init<Content: View>(
        _ route: Routes,
        _ options: ScreenOptions? = nil,
        @ViewBuilder content: @escaping (Navigation<Routes>, any Route) -> Content
    ) {
        self.route = route
        self.options = options
        self.build = { navigation, route in
            AnyView(content(navigation, route))
        }
    }
}
