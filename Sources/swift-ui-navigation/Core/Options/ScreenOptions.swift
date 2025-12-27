//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 24/12/25.
//

import Foundation
import SwiftUI

public struct ScreenOptions {
    var title: String? // fallback to the route name itself
    let hideHeaderTitle: Bool?
    var headerShown: Bool
    var headerBackButtonDisplayMode: NavigationBarItem.TitleDisplayMode?
    var headerBackButtonHidden: Bool?
    
    // header button options
    var headerLeftView: HeaderLeftView?
    var headerRightView: HeaderRightView?
    var headerStyle: HeaderStyle?

    
    public init (
        title: String? = nil,
        hideHeaderTitle: Bool? = false,
        headerShown: Bool? = true,
        headerBackButtonDisplayMode: NavigationBarItem.TitleDisplayMode? = .inline,
        headerBackButtonHidden: Bool? = false,
        
        headerLeftView: HeaderLeftView? = nil,
        headerRightView: HeaderRightView? = nil,
        headerStyle: HeaderStyle? = nil
    ) {
        self.title = title
        self.hideHeaderTitle = hideHeaderTitle
        self.headerShown = headerShown ?? true
        self.headerBackButtonDisplayMode = headerBackButtonDisplayMode
        self.headerBackButtonHidden = headerBackButtonHidden
        
        self.headerLeftView = headerLeftView
        self.headerRightView = headerRightView
        self.headerStyle = headerStyle
        
    }
}

@MainActor
enum ScreenOptionsProvider<Routes: Route> {
    case constant(ScreenOptions)
    case dynamic((StackNavigation<Routes>, Routes) -> ScreenOptions?)
    
    func resolve(
        navigation: StackNavigation<Routes>,
        _ route: Routes
    ) -> ScreenOptions? {
        switch self {
        case .constant(let options):
            return options
        case .dynamic(let closure):
            return closure(navigation, route)
        }
    }
}

@MainActor
@propertyWrapper
public struct AppScreenOptionsState: DynamicProperty {
    @EnvironmentObject private var screenOptionsState: ScreenOptionsState
        
    public var wrappedValue: ScreenOptionsState {
        screenOptionsState
    }
   
    public init() {}
}

@MainActor
public class ScreenOptionsState: ObservableObject {
    @Published var options: ScreenOptions
    
    init(options: ScreenOptions) {
        self.options = options
    }
    
    public var navigationTitle: String {
        get {
            options.title ?? ""
        }
        set {
            options.title = newValue
        }
    }
    
    public var headerBackButtonDisplayMode: NavigationBarItem.TitleDisplayMode {
        get {
            options.headerBackButtonDisplayMode ?? .inline
        }
        set {
            options.headerBackButtonDisplayMode = newValue
        }
    }
    
    var headerVisibility: Visibility {
        get {
            options.headerShown ? .visible : .hidden
        }
    }
    
    public var headerShown: Bool {
        get {
            options.headerShown
        }
        set {
            options.headerShown = newValue
        }
    }
    
    public var headerBackButtonHidden: Bool {
        get {
            options.headerBackButtonHidden ?? false
        }
        set {
            options.headerBackButtonHidden = newValue
        }
    }
    
    var hasCustomBackButton: Bool {
        get {
            headerLeftView != nil
        }
    }
    
    public var headerLeftView: HeaderLeftView? {
        get {
            options.headerLeftView
        }
        set {
            options.headerLeftView = newValue
        }
    }
    
    public var headerRightView: HeaderRightView? {
        get {
            options.headerRightView
        }
        set {
            options.headerRightView = newValue
        }
    }
    
    public var headerStyle: HeaderStyle {
        get {
            options.headerStyle ?? HeaderStyle(.clear, isVisible: true)
        } set {
            options.headerStyle = newValue
        }
    }

}

