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
    
    @StateObject private var anyNavigation: AnyNavigation
    private var navigation: Navigation<Routes>
    
    var initialRoute: Routes
    var screenOptionsProvider: ScreenOptionsProvider<Routes>?
    var screens: [StackScreen<Routes>]
    
    init(
        initialRoute: Routes,
        screens: [StackScreen<Routes>]
    ) {
        let anyNavigation = AnyNavigation()
        _anyNavigation = StateObject(wrappedValue: anyNavigation)
        self.navigation = Navigation<Routes>(anyNavigation)
        self.initialRoute = initialRoute
        self.screenOptionsProvider = nil
        self.screens = screens
    }
    
    init(
        initialRoute: Routes,
        screenOptions: ScreenOptions? = nil,
        screens: [StackScreen<Routes>]
    ) {
        let anyNavigation = AnyNavigation()
        _anyNavigation = StateObject(wrappedValue: anyNavigation)
        self.navigation = Navigation<Routes>(anyNavigation)
        self.initialRoute = initialRoute
        self.screenOptionsProvider = screenOptions.map({ .constant($0) })
        self.screens = screens
    }
    
    init(
        initialRoute: Routes,
        screenOptions: ((Navigation<Routes>, Routes) -> ScreenOptions?)? = nil,
        screens: [StackScreen<Routes>]
    ) {
        let anyNavigation = AnyNavigation()
        _anyNavigation = StateObject(wrappedValue: anyNavigation)
        self.navigation = Navigation<Routes>(anyNavigation)
        self.initialRoute = initialRoute
        self.screenOptionsProvider = screenOptions.map({ .dynamic($0) })
        self.screens = screens
    }
    
    
    private func getScreenOptions(_ route: Routes) -> ScreenOptions? {
        guard let provider = screenOptionsProvider else { return nil }
        switch provider {
        case .constant(let options):
            return options
        case .dynamic(let closure):
            return closure(navigation, route)
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarLeftViewContent() -> some ToolbarContent {
        
        if let topRoute = anyNavigation.routes.last,
           let screen = screens.first(where: { $0.route.name == topRoute.name }),
           let option = screen.getOptions(navigation) ?? getScreenOptions(screen.route),
           let headerLeftView = option.headerLeftView
        {
            ToolbarItem(placement: .topBarLeading) {
                headerLeftToolbarContent(headerLeftView)
            }
        } else if let screen = screens.first(where: { $0.route.name == initialRoute.name }), // check for initial route
                  let option = screen.getOptions(navigation) ?? getScreenOptions(screen.route),
                  let headerLeftView = option.headerLeftView
        {
            ToolbarItem(placement: .topBarLeading) {
                headerLeftToolbarContent(headerLeftView)
            }
        }
        
    }
    
    @ToolbarContentBuilder
    private func toolbarRightViewContent() -> some ToolbarContent {
        if let topRoute = anyNavigation.routes.last,
           let screen = screens.first(where: { $0.route.name == topRoute.name }),
           let option = screen.getOptions(navigation) ?? getScreenOptions(screen.route),
           let headerRightView = option.headerRightView
        {
            ToolbarItem(placement: .topBarTrailing) {
                headerRightToolbarContent(headerRightView)
            }
        } else if let screen = screens.first(where: { $0.route.name == initialRoute.name }), // check for initial route
                  let option = screen.getOptions(navigation) ?? getScreenOptions(screen.route),
                  let headerRightView = option.headerRightView
        {
            ToolbarItem(placement: .topBarTrailing) {
                headerRightToolbarContent(headerRightView)
            }
        }
    }
    
    public var body: some View {
        NavigationStack(path: $anyNavigation.routes) {
            renderScreen(for: initialRoute)
                .toolbar {
                    toolbarLeftViewContent()
                    toolbarRightViewContent()
                }
                .navigationDestination(for: AnyRoute.self) { route in
                    renderScreen(for: route)
                    .toolbar {
                        toolbarLeftViewContent()
                        toolbarRightViewContent()
                    }
                }
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
                anyNavigation.goBack()
            }, label: {
                HStack(alignment: .firstTextBaseline) {
                    if let image = headerLeftBasicView.image {
                        Image(image)
                    }
                    if let systemImage = headerLeftBasicView.systemImage {
                        Image(systemName: systemImage)
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
    
    @ViewBuilder
    private func renderScreen(for route: any Route) -> some View {
        // Make sure route name are unique. Write this in the Documentation
        if let screen = screens.first(where: { $0.route.name == route.name }) {
            
            let options = screen.getOptions(navigation)
            let screenOptions = getScreenOptions(screen.route)
            
            let title = options?.title ?? screenOptions?.title ?? screen.route.name
            let hideHeaderTitle = options?.hideHeaderTitle ?? screenOptions?.hideHeaderTitle ?? false
            let headerShown = options?.headerShown ?? screenOptions?.headerShown ?? true
            let headerBackButtonDisplayMode = options?.headerBackButtonDisplayMode ?? screenOptions?.headerBackButtonDisplayMode ?? .inline
            let headerBackButtonHidden = options?.headerBackButtonHidden ?? screenOptions?.headerBackButtonHidden ?? false
            
            let headerLeftView = options?.headerLeftView ?? screenOptions?.headerLeftView ?? nil
            
            let hasCustomBackButton = headerLeftView != nil
            let headerStyle = options?.headerStyle ?? screenOptions?.headerStyle ?? HeaderStyle(
                    .clear,
                    isTranslucent: true
                )
            
            screen.build(navigation, route)
                .navigationTitle(hideHeaderTitle ? "" : title)
                .navigationBarTitleDisplayMode(headerBackButtonDisplayMode)
                .toolbar(headerShown ? .visible : .hidden, for: .navigationBar)
                .navigationBarBackButtonHidden(headerBackButtonHidden || hasCustomBackButton)
                .toolbarBackground(
                    headerStyle.style,
                    for: .navigationBar
                )
                .toolbarBackground(
                    headerStyle.isTranslucent == true ? .visible : .automatic,
                    for: .navigationBar
                )
                .environmentObject(anyNavigation)
                .environment(\.navigation, anyNavigation)
                
        } else {
            Text("Screen '\(String(describing: route))' not found")
                .foregroundStyle(.red)
        }
    }
}



