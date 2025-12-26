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
    
    @State private var screenOptions: ScreenOptions?
    
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
                navigation.goBack()
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
        NavigationStack(path: $anyNavigation.routes) {
            renderScreen(for: initialRoute)
                .toolbar {
                    toolbarLeftViewContent()
                    toolbarRightViewContent()
                }
                .onReceive(anyNavigation.currentScreenOptionsState.$options, perform: { output in
                    screenOptions = output
                })
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
    private func renderScreen(for route: any Route) -> some View {
        if let screen = screens.first(where: { $0.route.name == route.name }) {
            StackScreenView(
                screen: screen,
                screenOptions: getScreenOptions(initialRoute),
                navigation: navigation
            )
            .environmentObject(anyNavigation)
        } else {
            Text("Screen '\(String(describing: route))' not found")
                            .foregroundStyle(.red)
        }
    }
}



