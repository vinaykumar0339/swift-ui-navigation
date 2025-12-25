//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 24/12/25.
//

import Foundation
import SwiftUI

@MainActor
public func createStackNavigator<Routes: Route>(
    _ routes: Routes.Type
) -> StackNavigatorFactory<Routes> {
    return StackNavigatorFactory<Routes>()
}

@MainActor
@resultBuilder
public struct StackBuilder {
    
    public static func buildExpression<Routes: Route>(
        _ expression: StackScreen<Routes>
    ) -> [StackScreen<Routes>] {
        [expression]
    }

    public static func buildBlock<Routes: Route>(
        _ components: [StackScreen<Routes>]...
    ) -> [StackScreen<Routes>] {
        components.flatMap { $0 }
    }

    public static func buildOptional<Routes: Route>(
        _ component: [StackScreen<Routes>]?
    ) -> [StackScreen<Routes>] {
        component ?? []
    }

    public static func buildEither<Routes: Route>(
        first component: [StackScreen<Routes>]
    ) -> [StackScreen<Routes>] {
        component
    }

    public static func buildEither<Routes: Route>(
        second component: [StackScreen<Routes>]
    ) -> [StackScreen<Routes>] {
        component
    }

    public static func buildArray<Routes: Route>(
        _ components: [[StackScreen<Routes>]]
    ) -> [StackScreen<Routes>] {
        components.flatMap { $0 }
    }
    
}

@MainActor
public struct StackNavigator<Routes: Route>: View {
    
    @EnvironmentObject var navigation: AnyNavigation
    @AppNavigation<Routes> private var appNavigation
    
    let initialRoute: Routes
    let screenOptions: ScreenOptions?
    let screens: [StackScreen<Routes>]
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        
        if let topRoute = navigation.routes.last,
           let screen = screens.first(where: { $0.route.name == topRoute.name }),
           let option = screen.options?.headerLeftButtonOption {
            ToolbarItem(placement: .topBarLeading) {
                headerLeftToolbarContent(option)
            }
        } else if let screen = screens.first(where: { $0.route.name == initialRoute.name }), // check for initial route
           let option = screen.options?.headerLeftButtonOption {
            ToolbarItem(placement: .topBarLeading) {
                headerLeftToolbarContent(option)
            }
        }
        
    }

    
    public var body: some View {
        NavigationStack(path: $navigation.routes) {
            renderScreen(for: initialRoute)
                .toolbar {
                    toolbarContent()
                }
                .navigationDestination(for: AnyRoute.self) { route in
                    renderScreen(for: route)
                    .toolbar {
                        toolbarContent()
                    }
                }
        }
    }
    
    @ViewBuilder
    private func headerLeftToolbarContent(
        _ option: HeaderLeftButtonOption
    ) -> some View {
        switch option {
        case .none:
            EmptyView()

        case .basic(let opt):
            HStack(alignment: .firstTextBaseline) {
                opt.icon
                    .foregroundColor(.primary)
                VStack(alignment: .leading) {
                    if let title = opt.title {
                        Text(title)
                            .foregroundStyle(.primary)
                    }
                    if let subtitle = opt.subtitle {
                        Text(subtitle)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .onTapGesture {
                if let action = opt.action {
                    action()
                }
                // if not provided the action befault should be go back.
                navigation.goBack()
            }

        case .custom(let builder):
            builder()
        }
    }

    
    @ViewBuilder
    private func renderScreen(for route: any Route) -> some View {
        // Make sure route name are unique. Write this in the Documentation
        if let screen = screens.first(where: { $0.route.name == route.name }) {
            
            let title = screen.options?.title ?? screenOptions?.title ?? screen.route.name
            let headerShown = screen.options?.headerShown ?? screenOptions?.headerShown ?? true
            let headerBackButtonDisplayMode = screen.options?.headerBackButtonDisplayMode ?? screenOptions?.headerBackButtonDisplayMode ?? .inline
            let headerBackButtonHidden = screen.options?.headerBackButtonHidden ?? screenOptions?.headerBackButtonHidden ?? false
            
            let headerLeftButtonOption = screen.options?.headerLeftButtonOption ?? screenOptions?.headerLeftButtonOption ?? nil
            
            let hasCustomBackButton = headerLeftButtonOption != nil
            
            screen.build(appNavigation, route)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(headerBackButtonDisplayMode)
                .toolbar(headerShown ? .visible : .hidden, for: .navigationBar)
                .navigationBarBackButtonHidden(headerBackButtonHidden || hasCustomBackButton)
                
        } else {
            Text("Screen '\(String(describing: route))' not found")
                .foregroundStyle(.red)
        }
    }
}

@MainActor
public struct StackNavigatorFactory<Routes: Route> {
    
    public func Screen(
        route: Routes,
        options: ScreenOptions? = nil,
        @ViewBuilder content: @escaping (Navigation<Routes>, any Route) -> some View
    ) -> StackScreen<Routes> {
        StackScreen(route, options, content: content)
    }
    
    public func Navigator(
        initialRoute: Routes,
        screenOptions: ScreenOptions? = nil,
        @StackBuilder content: () -> [StackScreen<Routes>]
    ) -> StackNavigator<Routes> {
        StackNavigator(initialRoute: initialRoute, screenOptions: screenOptions, screens: content())
    }
    
}

