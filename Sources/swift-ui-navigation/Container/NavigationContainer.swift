//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 24/12/25.
//

import Foundation
import SwiftUI

struct NavigationKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue: Navigation = .init()
}

extension EnvironmentValues {
    var navigation: Navigation {
        get {
            self[NavigationKey.self]
        } set {
            self[NavigationKey.self] = newValue
        }
    }
}

public struct NavigationContainer<Content: View>: View {
    
    @StateObject private var navigation = Navigation()
    
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .environment(\.navigation, navigation)
    }
}
