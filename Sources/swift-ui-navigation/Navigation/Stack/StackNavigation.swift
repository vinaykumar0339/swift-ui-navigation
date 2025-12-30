//
//  Navigation.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 25/12/25.
//


import Foundation
import SwiftUI

@MainActor
@propertyWrapper
public struct AppStackNavigator<Routes: Route>: DynamicProperty {
    @Environment(\.navigation) private var navigation
    
    public init() {}
    
    public var wrappedValue: StackNavigation<Routes> {
        guard let stackNavigation =
            navigation.resolveStackNavigation(Routes.self)
        else {
            fatalError("""
            No StackNavigation<\(Routes.self)> found in environment.
            Make sure that AppStackNavigator used inside the view of NavigationContainer where you have registered your view.
            """)
        }
        return stackNavigation
    }
}

@MainActor
public class StackNavigation<Routes: Route>: ObservableObject, BaseNavigation {
    
    public typealias Routes = Routes
    
    @Published var routes = [Routes]()
    
    @Published var currentScreenOptionsState: ScreenOptionsState = ScreenOptionsState(options: ScreenOptions())
    
    init(
        routes: [Routes] = [Routes](),
        currentScreenOptionsState: ScreenOptionsState = ScreenOptionsState(options: ScreenOptions())
    ) {
        self.routes = routes
        self.currentScreenOptionsState = currentScreenOptionsState
    }
    
    public func navigate(to route: Routes) {
        routes.append(route)
    }
    
    public func pop() {
        guard !routes.isEmpty else { return }
        routes.removeLast()
    }
    
    public func popToTop() {
        routes.removeAll(keepingCapacity: false)
    }
    
    public func goBack(_ times: Int = 1) {
        for _ in 1...times {
            pop()
        }
    }
    
    public func canGoBack() -> Bool {
        return !routes.isEmpty
    }
    
    func register(_ state: ScreenOptionsState) {
        currentScreenOptionsState = state
    }
}
