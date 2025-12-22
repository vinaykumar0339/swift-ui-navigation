//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 22/12/25.
//

import Foundation
import SwiftUI

@MainActor
public final class Navigation<
    Screen: ScreenProtocol
>: ObservableObject {
    @Published internal var path: [Route<Screen>] = []
    
    public init() {}
    
    public func navigate<Params: RouteParams>(_ name: Screen, params: Params) {
        let route = Route(name: name, params: params)
        path.append(route)
    }
    
    public func navigate(_ name: Screen) {
        let route = Route(name: name, params: EmptyParams())
        path.append(route)
    }
    
    public func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    public func replace<Params: RouteParams>(
        _ name: Screen,
        params: Params
    ) where Params: RouteParams {
        goBack()
        navigate(name, params: params)
    }
    
    public func replace(_ name: Screen) {
       goBack()
       navigate(name)
   }
    
    public func reset(to routes: [Route<Screen>] = []) {
        path = routes
    }
    
    public func popToTop() {
        path.removeAll()
    }
    
    public var canGoBack: Bool {
        !path.isEmpty
    }
    
    public func setParams<Params: RouteParams>(_ params: Params) {
        guard let last = path.last else { return }

        let updated = Route(
            name: last.name,
            params: params,
            options: last.getOptions()
        )

        path[path.count - 1] = updated
    }
    
    public func setOptions(_ options: ScreenOptions) {
        guard var last = path.last else { return }
        
        last.updateOptions(options)
        last.id = UUID() // to tell the navigation stack that this new screen options.
        
        path[path.count - 1] = last
    }
}
