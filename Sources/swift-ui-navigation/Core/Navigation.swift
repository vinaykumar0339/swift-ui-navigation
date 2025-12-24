//
//  Navigation.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 25/12/25.
//


import Foundation
import SwiftUI

@MainActor
public class AnyNavigation: ObservableObject {
    @Published var routes = [AnyRoute]()
    
    public func navigate<R: Route>(to destination: R) {
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
}

@MainActor
@propertyWrapper
public struct AppNavigation<R: Route>: DynamicProperty {
    @EnvironmentObject private var navigation: AnyNavigation

    public var wrappedValue: Navigation<R> {
        Navigation(navigation)
    }

    public init() {}
}

@MainActor
public struct Navigation<R: Route> {
    private let navigation: AnyNavigation

    init(_ navigation: AnyNavigation) {
        self.navigation = navigation
    }

    public func navigate(to route: R) {
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
