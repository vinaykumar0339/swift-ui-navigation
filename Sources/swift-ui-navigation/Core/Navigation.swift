//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 29/12/25.
//

import Foundation
import SwiftUI

@MainActor
public protocol BaseNavigation {
    associatedtype Routes: Route
    func navigate(to route: Routes)
    func pop()
    func popToTop()
    func goBack(_ times: Int)
    func canGoBack() -> Bool
}


@MainActor
@propertyWrapper
public struct AppNavigation: DynamicProperty {
    @Environment(\.navigation) private var navigation
    
    public init() {}
    
    public var wrappedValue: Navigation {
        navigation
    }
}

@MainActor
public class Navigation: ObservableObject {
    
    typealias Routes = Route
    
    private var navigator: (any BaseNavigation)?
    weak private var parent: Navigation?
    
    public init(navigator: (any BaseNavigation)? = nil) {
        self.navigator = navigator
    }
    
    public func setParent(_ parent: Navigation) {
        self.parent = parent
    }
    
    // TODO: need to rethink this navigate method for complex nested routes.
    public func navigate<Routes: Route>(to route: Routes) {
        if let stackNavigation = navigator as? StackNavigation<Routes> {
            return stackNavigation.navigate(to: route)
        } else if let tabNavigation = navigator as? TabNavigation<Routes> {
            return tabNavigation.navigate(to: route)
        } // here we can tell to the parent to handle if not handled by the current navigator
        else if let parent {
            return parent.navigate(to: route)
        } else {
            print("not handled by current navigator. check your route configuration")
        }
    }
    
    public func pop() {
        guard let navigator else {
            return
        }
        if navigator.canGoBack() == true {
            return navigator.pop()
        } else if let parent {
            return parent.pop()
        } else {
            print("no navigation to pop")
        }
    }
    
    public func popToTop() {
        guard let navigator else {
            return
        }
        if navigator.canGoBack() == true {
            return navigator.popToTop()
        } else if let parent {
            return parent.popToTop()
        } else {
            print("no navigation to pop to top")
        }
    }
    
    public func canGoBack() -> Bool {
        guard let navigator else {
            return false
        }
        if navigator.canGoBack() == true {
            return true
        }
        return parent?.canGoBack() ?? false
    }
    
    public func goBack(_ times: Int = 1) {
        guard times > 0 else {
            print("times should be less than 1")
            return
        }
        
        guard let navigator else {
            return
        }
        
        if navigator.canGoBack() {
            return navigator.goBack(times)
        } else if let parent {
            return parent.goBack(times)
        } else {
            print("no navigation to go back")
        }
    }
    
    func resolveStackNavigation<StackRoutes: Route>(
        _ routes: StackRoutes.Type = StackRoutes.self
    ) -> StackNavigation<StackRoutes>? {
        guard let navigator else {
            return nil
        }
        
        if let stackNavigation = navigator as? StackNavigation<StackRoutes> {
            return stackNavigation
        } else if let parent {
            if let stackNavigation = parent.resolveStackNavigation(routes) {
                return stackNavigation
            } else {
                return nil
            }
        }
        return nil
    }
    
    func resolveTabNavigation<TabRoutes: Route>(
        _ routes: TabRoutes.Type = TabRoutes.self
    ) -> TabNavigation<TabRoutes>? {
        guard let navigator else {
            return nil
        }
        
        if let tabNavigation = navigator as? TabNavigation<TabRoutes> {
            return tabNavigation
        } else if let parent {
            if let tabNavigation = parent.resolveTabNavigation(routes) {
                return tabNavigation
            } else {
                return nil
            }
        }
        
        return nil
    }
    
}
