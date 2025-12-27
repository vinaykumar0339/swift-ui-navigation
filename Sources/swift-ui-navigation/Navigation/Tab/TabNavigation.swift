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
    
    @Published var routes = [AnyRoute]()
    
    init(selectedRoute: AnyRoute? = nil, routes: [AnyRoute] = [AnyRoute]()) {
        self.selectedRoute = selectedRoute
        self.routes = routes
    }
    
    public func navigate<Routes: Route>(to route: Routes) {
        let anyRoute = AnyRoute(route)
        routes.append(anyRoute)
        selectedRoute = anyRoute
    }
    
    func pop() {
        guard !routes.isEmpty else { return }
        routes.removeLast()
        // set the current last route
        selectedRoute = routes.last
    }
    
    func popToTop() {
        guard !routes.isEmpty else { return }
        
        // remove all existing routes but keep start route.
        routes.removeSubrange(1..<routes.count)
        selectedRoute = routes.last
    }
    
    func goBack(_ times: Int = 1) {
        for _ in 1...times {
            pop()
        }
    }
    
    func canGoBack() -> Bool {
        return routes.count > 1
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
    
    public func navigate(to route: Routes) {
        appTabNavigation.navigate(to: route)
    }
    
    public func pop() {
        appTabNavigation.pop()
    }
    
    public func popToRoot() {
        appTabNavigation.popToTop()
    }
    
    public func goBack(_ times: Int = 1) {
        appTabNavigation.goBack(times)
    }
    
    public var canGoBack: Bool {
        appTabNavigation.canGoBack()
    }
}
