//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 22/12/25.
//

import Foundation
import SwiftUI

@MainActor
public final class Navigation<Screen: ScreenProtocol>: ObservableObject {
    @Published internal var path: [Route<Screen>] = []
    @Published public var currentOptions: ScreenOptions?
    
    public init() {}
    
    public func navigate<Params>(_ name: Screen, params: Params) where Params: Codable & Hashable {
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
    
    public func replace<Params>(
        _ name: Screen,
        params: Params
    ) where Params: Codable & Hashable {
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
    
    public func setParams<Params>(_ params: Params) where Params: Codable & Hashable {
        guard !path.isEmpty else { return }
        path[path.count - 1].updateParams(params)
    }
    
    public func setOptions(_ options: ScreenOptions) {
        currentOptions = options
    }
}
