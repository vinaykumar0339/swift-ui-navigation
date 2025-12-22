//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 22/12/25.
//

import Foundation
import SwiftUI

public struct StackNavigator<R: Route, Content: View>: View {
    
    @StateObject private var router = Router<R>()
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            content
                .environmentObject(router)
        }
    }
    
}
