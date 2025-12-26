//
//  Navigation.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 25/12/25.
//


import Foundation
import SwiftUI

/// Type-erased navigation which is used in the @AppStackNavigation<Routes> to access the navigation
/// EnvironmentKey is not supported the generic types like EnvironemtObject

@MainActor
class AnyStackNavigation: ObservableObject {
    @Published var routes = [AnyRoute]()
    
    @Published var currentScreenOptionsState: ScreenOptionsState = ScreenOptionsState(options: ScreenOptions())
    
    public func navigate<Routes: Route>(to destination: Routes) {
        let route = AnyRoute(destination)
        routes.append(route)
    }
    
    public func pop() {
        guard !routes.isEmpty else { return }
        routes.removeLast()
    }
    
    public func popToTop() {
        routes.removeAll(keepingCapacity: false)
    }
    
    public func goBack() {
        pop()
    }
    
    public func canGoBack() -> Bool {
        return !routes.isEmpty
    }
    
    internal func register(_ state: ScreenOptionsState) {
        currentScreenOptionsState = state
    }
}

@MainActor
@propertyWrapper
public struct AppStackNavigation<Routes: Route>: DynamicProperty {
    @EnvironmentObject private var navigation: AnyStackNavigation

    public var wrappedValue: StackNavigation<Routes> {
        StackNavigation(navigation)
    }

    public init() {}
}

@MainActor
public struct StackNavigation<Routes: Route> {
    private let navigation: AnyStackNavigation

    init(_ navigation: AnyStackNavigation) {
        self.navigation = navigation
    }

    public func navigate(to route: Routes) {
        navigation.navigate(to: route)
    }
    
    public func pop() {
        navigation.pop()
    }
    
    public func popToTop() {
        navigation.popToTop()
    }

    public func goBack() {
        navigation.goBack()
    }
    
    public var canGoBack: Bool {
        navigation.canGoBack()
    }
}
