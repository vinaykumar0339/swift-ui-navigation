//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 26/12/25.
//

import Foundation
import SwiftUI

/// Type-erased navigation which is used in the @AppTabNavigation<Routes> to access the navigation
/// EnvironmentKey is not supported the generic types like EnvironemtObject
@MainActor
class AnyTabNavigation: ObservableObject {
    @Published var selectedRoute: AnyRoute?
    
    public func switchTab<Routes: Route>(to route: Routes) {
        selectedRoute = AnyRoute(route)
    }
}


@MainActor
@propertyWrapper
public struct AppTabNavigation<Routes: Route>: DynamicProperty {
    @EnvironmentObject private var tabNavigation: AnyTabNavigation
    
    public var wrappedValue: TabNavigation<Routes> {
        TabNavigation(tabNavigation)
    }
    
    public init() {}
}

@MainActor
public struct TabNavigation<Routes: Route> {
    private let appTabNavigation: AnyTabNavigation
    
    init(_ appTabNavigation: AnyTabNavigation) {
        self.appTabNavigation = appTabNavigation
    }
    
    public func switchTab(to route: Routes) {
        appTabNavigation.switchTab(to: route)
    }
}
