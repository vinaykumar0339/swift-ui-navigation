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
    
    func navigate<Routes: Route>(to destination: Routes) {
        let route = AnyRoute(destination)
        routes.append(route)
    }
    
    func pop() {
        guard !routes.isEmpty else { return }
        routes.removeLast()
    }
    
    func popToTop() {
        routes.removeAll(keepingCapacity: false)
    }
    
    func goBack(_ times: Int = 1) {
        for _ in 1...times {
            pop()
        }
    }
    
    func canGoBack() -> Bool {
        return !routes.isEmpty
    }
    
    func register(_ state: ScreenOptionsState) {
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

    public func goBack(_ times: Int = 1) {
        navigation.goBack(times)
    }
    
    public var canGoBack: Bool {
        navigation.canGoBack()
    }
}
