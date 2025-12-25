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
    
    public init(
        title: String? = nil,
        headerShown: Bool? = true,
        headerBackButtonDisplayMode: NavigationBarItem.TitleDisplayMode? = .inline,
        headerBackButtonHidden: Bool? = false
    ) {
        self.title = title
        self.headerShown = headerShown
        self.headerBackButtonDisplayMode = headerBackButtonDisplayMode
        self.headerBackButtonHidden = headerBackButtonHidden
    }
}
