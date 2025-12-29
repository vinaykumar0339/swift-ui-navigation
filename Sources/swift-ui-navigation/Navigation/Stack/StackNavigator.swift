//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 24/12/25.
//

import Foundation
import SwiftUI

@MainActor
public struct StackNavigator<Routes: Route>: View {
    
    @StateObject private var anyStackNavigation: AnyStackNavigation
    private var stackNavigation: StackNavigation<Routes>
    
    // get current local navigation. to set the parent child relationship
    @Environment(\.navigation) var navigation
    @StateObject private var localNavigation: Navigation
    
    var initialScreen: StackScreen<Routes>
    var screenOptionsProvider: ScreenOptionsProvider<Routes>?
    var stackScreens: [StackScreen<Routes>]
    
    @State private var screenOptions: ScreenOptions?
    
    init(
        initialScreen: StackScreen<Routes>,
        screens: [StackScreen<Routes>]
    ) {
        let anyStackNavigation = AnyStackNavigation()
        _anyStackNavigation = StateObject(wrappedValue: anyStackNavigation)
        
        self.stackNavigation = StackNavigation<Routes>(anyStackNavigation)
        
        let localNavigation = Navigation(navigator: self.stackNavigation)
        _localNavigation = StateObject(wrappedValue: localNavigation)
        
        self.initialScreen = initialScreen
        self.screenOptionsProvider = nil
        self.stackScreens = screens
    }
    
    init(
        initialScreen: StackScreen<Routes>,
        screenOptions: ScreenOptions? = nil,
        screens: [StackScreen<Routes>]
    ) {
        let anyStackNavigation = AnyStackNavigation()
        _anyStackNavigation = StateObject(wrappedValue: anyStackNavigation)
        
        self.stackNavigation = StackNavigation<Routes>(anyStackNavigation)
        
        let localNavigation = Navigation(navigator: self.stackNavigation)
        _localNavigation = StateObject(wrappedValue: localNavigation)
        
        self.initialScreen = initialScreen
        self.screenOptionsProvider = screenOptions.map({ .constant($0) })
        self.stackScreens = screens
    }
    
    init(
        initialScreen: StackScreen<Routes>,
        screenOptions: ((StackNavigation<Routes>, Routes) -> ScreenOptions?)? = nil,
        screens: [StackScreen<Routes>]
    ) {
        let anyNavigation = AnyStackNavigation()
        _anyStackNavigation = StateObject(wrappedValue: anyNavigation)
        
        self.stackNavigation = StackNavigation<Routes>(anyNavigation)
        
        let localNavigation = Navigation(navigator: self.stackNavigation)
        _localNavigation = StateObject(wrappedValue: localNavigation)
        
        self.initialScreen = initialScreen
        self.screenOptionsProvider = screenOptions.map({ .dynamic($0) })
        self.stackScreens = screens
    }
    
    
    private func getScreenOptions(_ route: Routes) -> ScreenOptions? {
        guard let provider = screenOptionsProvider else { return nil }
        switch provider {
        case .constant(let options):
            return options
        case .dynamic(let closure):
            return closure(stackNavigation, route)
        }
    }
    
    @ViewBuilder
    private func headerLeftToolbarContent(
        _ option: HeaderLeftView
    ) -> some View {
        switch option {
        case .none:
            EmptyView()
            
        case .basic(let headerLeftBasicView):
            Button(action: {
                if let action = headerLeftBasicView.action {
                    action()
                }
                // if not provided the action befault should be go back.
                stackNavigation.goBack()
            }, label: {
                HStack(alignment: .center) {
                    if let image = headerLeftBasicView.image {
                        Image(image)
                    } else if let systemImage = headerLeftBasicView.systemImage {
                        Image(systemName: systemImage)
                    } else {
                        Image(systemName: "chevron.left")
                    }
                    VStack(alignment: .leading) {
                        if let title = headerLeftBasicView.title {
                            Text(title)
                                .font(.headline)
                        }
                        if let subtitle = headerLeftBasicView.subtitle {
                            Text(subtitle)
                                .font(.subheadline)
                        }
                    }
                }
            })
        case .custom(let builder):
            builder()
        }
    }
    
    @ViewBuilder
    private func headerRightToolbarContent(
        _ option: HeaderRightView
    ) -> some View {
        switch option {
        case .none:
            EmptyView()
        case .items(let headerRightViewItems):
            HStack {
                ForEach(Array(headerRightViewItems.enumerated()), id: \.offset) { _, action in
                    Button(action: action.action) {
                        action.content
                    }
                }
            }
        case .custom(let builder):
            builder()
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarLeftViewContent() -> some ToolbarContent {
        if let headerLeftView = screenOptions?.headerLeftView {
            ToolbarItem(placement: .topBarLeading) {
                headerLeftToolbarContent(headerLeftView)
            }
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarRightViewContent() -> some ToolbarContent {
        if let headerRightView = screenOptions?.headerRightView {
            ToolbarItem(placement: .topBarTrailing) {
                headerRightToolbarContent(headerRightView)
            }
        }
    }
    
    public var body: some View {
        NavigationStack(path: $anyStackNavigation.routes) {
            renderInitialScreen(for: initialScreen)
                .onReceive(anyStackNavigation.currentScreenOptionsState.$options, perform: { output in
                    screenOptions = output
                })
                .navigationDestination(for: AnyRoute.self) { route in
                    renderScreen(for: route)
                    .toolbar {
                        toolbarLeftViewContent()
                        toolbarRightViewContent()
                    }
                }
                .toolbar {
                    toolbarLeftViewContent()
                    toolbarRightViewContent()
                }
        }
        .onAppear {
            // TODO: Check this can be moved to init, as environment variable can't be accessed in the init
            localNavigation.setParent(navigation)
        }
        .environment(\.navigation, localNavigation)
        .environmentObject(anyStackNavigation)
    }
    
    @ViewBuilder
    private func renderInitialScreen(for screen: StackScreen<Routes>) -> some View {
        StackScreenView(
            screen: screen,
            screenOptions: getScreenOptions(screen.route),
            navigation: stackNavigation
        )
    }
    
    @ViewBuilder
    private func renderScreen(for route: any Route) -> some View {
        if let screen = stackScreens.first(where: { $0.route.name == route.name }) {
            StackScreenView(
                screen: screen,
                screenOptions: getScreenOptions(initialScreen.route),
                navigation: stackNavigation
            )
        } else {
            Text("Screen '\(String(describing: route))' not found")
                            .foregroundStyle(.red)
        }
    }
}



