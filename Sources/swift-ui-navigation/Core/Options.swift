//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 24/12/25.
//

import Foundation
import SwiftUI

public struct ScreenOptions {
    let title: String? // fallback to the route name itself
    let headerShown: Bool?
    let headerBackButtonDisplayMode: NavigationBarItem.TitleDisplayMode?
    let headerBackButtonHidden: Bool?
    
    // header button options
    let headerLeftButtonOption: HeaderLeftButtonOption?
    
    public init(
        title: String? = nil,
        headerShown: Bool? = true,
        headerBackButtonDisplayMode: NavigationBarItem.TitleDisplayMode? = .inline,
        headerBackButtonHidden: Bool? = false,
        
        headerLeftButtonOption: HeaderLeftButtonOption? = nil
    ) {
        self.title = title
        self.headerShown = headerShown
        self.headerBackButtonDisplayMode = headerBackButtonDisplayMode
        self.headerBackButtonHidden = headerBackButtonHidden
        
        self.headerLeftButtonOption = headerLeftButtonOption
    }
}

public struct HeaderLeftButtonBasicOption {
    let icon: Image?
    let title: String?
    let subtitle: String?
    let action: (() -> Void)?
    
    init(icon: Image? = nil, title: String? = nil, subtitle: String? = nil, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
}

public enum HeaderLeftButtonOption {
    case none
    case basic(HeaderLeftButtonBasicOption)
    case custom(() -> AnyView)

}
