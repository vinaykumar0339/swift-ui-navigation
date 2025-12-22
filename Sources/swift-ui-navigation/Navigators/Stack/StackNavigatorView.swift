//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 22/12/25.
//

import Foundation
import SwiftUI

internal struct StackNavigatorView<Screen: ScreenProtocol>: View {
    @StateObject private var navigation = Navigation<Screen>()
    
    let initialRoute: Screen
    let screens: [ScreenConfiguration<Screen>]
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            renderScreen(for: Route(name: initialRoute, params: EmptyParams()))
                .environmentObject(navigation)
                .navigationDestination(for: Route<Screen>.self) { route in
                    renderScreen(for: route)
                        .environmentObject(navigation)
                }
        }
    }
    
    @ViewBuilder
    private func renderScreen(for route: Route<Screen>) -> some View {
        if let screen = screens.first(where: { $0.name == route.name }) {
            let options = navigation.currentOptions ?? screen.options
            
            screen.builder(route, navigation)
                .navigationTitle(options.title ?? "")
                .navigationBarTitleDisplayMode(.large)
                .toolbar(options.headerShown ? .visible : .hidden, for: .navigationBar)
                .onAppear {
                    navigation.currentOptions = nil
                }
        } else {
            Text("Screen '\(String(describing: route.name))' not found")
                .foregroundColor(.red)
        }
    }
}
