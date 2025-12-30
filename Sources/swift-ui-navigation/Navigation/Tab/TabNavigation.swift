//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 26/12/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
@propertyWrapper
public struct AppTabNavigator<Routes: Route>: DynamicProperty {
    @Environment(\.navigation) private var navigation
    
    public init() {}
    
    public var wrappedValue: TabNavigation<Routes> {
        guard let stackNavigation =
                navigation.resolveTabNavigation(Routes.self)
        else {
            fatalError("""
            No TabNavigation<\(Routes.self)> found in environment.
            Make sure that AppTabNavigator used inside the view of NavigationContainer where you have registered your view.
            """)
        }
        return stackNavigation
    }
}

@MainActor
public class TabNavigation<Routes: Route>: ObservableObject, BaseNavigation {
    
    @Published var selectedRoute: Routes?
    
    private var routes = [Routes]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(selectedRoute: Routes? = nil) {
        self.selectedRoute = selectedRoute
        if let selectedRoute {
            self.routes = [selectedRoute]
        }
        
        bindSelection()
    }
    
    private func bindSelection() {
        $selectedRoute
            .compactMap { $0 }
            .removeDuplicates()
            .sink { [weak self] route in
                self?.pushIfNeeded(route)
            }
            .store(in: &cancellables)
    }
    
    private func pushIfNeeded(_ route: Routes) {
        guard routes.last != route else { return }
        routes.append(route)
    }
    
    public func navigate(to route: Routes) {
        routes.append(route)
        selectedRoute = route
    }
    
    public func pop() {
        guard !routes.isEmpty else { return }
        routes.removeLast()
        // set the current last route
        selectedRoute = routes.last
    }
    
    public func popToTop() {
        guard !routes.isEmpty else { return }
        
        // remove all existing routes but keep start route.
        routes.removeSubrange(1..<routes.count)
        selectedRoute = routes.last
    }
    
    public func goBack(_ times: Int = 1) {
        for _ in 1...times {
            pop()
        }
    }
    
    public func canGoBack() -> Bool {
        return !routes.isEmpty
    }
}
