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
    
    func setParent(_ parent: Navigation) {
        self.parent = parent
    }
    
    @discardableResult
    func navigateInternal<Routes: Route>(to route: Routes) -> Bool {
        if let stackNavigation = navigator as? StackNavigation<Routes> {
            stackNavigation.navigate(to: route)
            return true
        } else if let tabNavigation = navigator as? TabNavigation<Routes> {
            tabNavigation.navigate(to: route)
            return true
        }
        else if let parent {
            return parent.navigateInternal(to: route)
        } else {
            print("not handled by current navigator. check your route configuration")
            return false
        }
    }
    
    public func navigate<Routes: Route>(to route: Routes) {
        navigateInternal(to: route)
    }
    
    /// push the new screen from the closest navigation
    /// Route should be valid route to resolve the current local stack or tab navigation. ignore the navigation
    /// if not able to find the current closest navigation is not able to resolve the route.
    public func push<Routes: Route>(route: Routes) {
        if let stackNavigation = navigator as? StackNavigation<Routes> {
            stackNavigation.navigate(to: route)
        } else if let tabNavigation = navigator as? TabNavigation<Routes> {
            tabNavigation.navigate(to: route)
        } else {
            print("\(route) of type \(Routes.self) is not able to handle by the current navigator \(String(describing: navigator)). check your route configuration")
        }
    }
    
    /// pop the current screen.
    /// if the local navigator is not able to handle then it bubble up till root navigation.
    /// if none of the navigator handles then it ignores the navigation.
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
    
    /// pop to the first screen of the navigation.
    /// if the local navigator is not able to handle then it bubble up till root navigation.
    /// if none of the navigator handles then it ignores the navigation.
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
    
    /// check if any navigation can handle the go back.
    /// this also bubble up till the root navigation if the local navigation not able to handle.
    public func canGoBack() -> Bool {
        guard let navigator else {
            return false
        }
        if navigator.canGoBack() == true {
            return true
        }
        return parent?.canGoBack() ?? false
    }
    
    /// go back n times in the navigation.
    /// this also bubble up till the root navigation if the local navigation not able to handle.
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
