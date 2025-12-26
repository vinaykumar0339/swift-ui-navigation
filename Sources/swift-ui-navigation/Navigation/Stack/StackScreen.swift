//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 24/12/25.
//

import Foundation
import SwiftUI

@MainActor
public struct StackScreen<Routes: Route> {
    
    let route: Routes
    let optionsProvider: ScreenOptionsProvider<Routes>?
    let build: (StackNavigation<Routes>, any Route) -> AnyView
    
    public init<Content: View>(
        _ route: Routes,
        @ViewBuilder content: @escaping (StackNavigation<Routes>, any Route) -> Content
    ) {
        self.route = route
        self.optionsProvider = nil
        self.build = { navigation, route in
            AnyView(content(navigation, route))
        }
    }
    
    public init<Content: View>(
        _ route: Routes,
        _ options: ScreenOptions? = nil,
        @ViewBuilder content: @escaping (StackNavigation<Routes>, any Route) -> Content
    ) {
        self.route = route
        self.optionsProvider = options.map({ .constant($0) })
        self.build = { navigation, route in
            AnyView(content(navigation, route))
        }
    }
    
    public init<Content: View>(
        _ route: Routes,
        _ options: ((StackNavigation<Routes>, Routes) -> ScreenOptions?)? = nil,
        @ViewBuilder content: @escaping (StackNavigation<Routes>, any Route) -> Content
    ) {
        self.route = route
        self.optionsProvider = options.map({ .dynamic($0) })
        self.build = { navigation, route in
            AnyView(content(navigation, route))
        }
    }
    
    func getOptions(_ navigation: StackNavigation<Routes>) -> ScreenOptions? {
        optionsProvider?.resolve(navigation: navigation, route)
    }
}

struct StackScreenNotFoundView: View {
    
    let route: any Route
    
    var body: some View {
        Text("Screen '\(String(describing: route))' not found")
            .foregroundStyle(.red)
    }
}

struct StackScreenView<Routes: Route>: View {
    
    let stackScreen: StackScreen<Routes>
    let screenOptions: ScreenOptions?
    let stackNavigation: StackNavigation<Routes>
    
    @StateObject private var screenOptionsState: ScreenOptionsState
    @EnvironmentObject private var anyStackNavigation: AnyStackNavigation
    
    init(screen: StackScreen<Routes>,
         screenOptions: ScreenOptions?,
         navigation: StackNavigation<Routes>
    ) {
        self.stackScreen = screen
        self.screenOptions = screenOptions
        self.stackNavigation = navigation
        
        let screenOptions = screen.getOptions(navigation) ?? self.screenOptions ?? ScreenOptions()
        
        _screenOptionsState = StateObject(
            wrappedValue: ScreenOptionsState(
                options: screenOptions
            )
        )
    }
    
    var body: some View {
        
        stackScreen
            .build(stackNavigation, stackScreen.route)
            .onAppear {
                anyStackNavigation.register(screenOptionsState)
            }
            .environmentObject(screenOptionsState) // current screen options state
            .navigationTitle(screenOptionsState.navigationTitle)
            .navigationBarTitleDisplayMode(screenOptionsState.headerBackButtonDisplayMode)
            .toolbar(screenOptionsState.headerVisibility, for: .navigationBar)
            .navigationBarBackButtonHidden(screenOptionsState.headerBackButtonHidden || screenOptionsState.hasCustomBackButton)
            .toolbarBackground(
                screenOptionsState.headerStyle.style,
                for: .navigationBar
            )
            .toolbarBackground(
                screenOptionsState.headerStyle.isTranslucent == true ? .visible : .automatic,
                for: .navigationBar
            )
            
    }
}
