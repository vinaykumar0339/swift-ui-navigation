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
    let hideHeaderTitle: Bool?
    let headerShown: Bool?
    let headerBackButtonDisplayMode: NavigationBarItem.TitleDisplayMode?
    let headerBackButtonHidden: Bool?
    
    // header button options
    let headerLeftView: HeaderLeftView?
    let headerRightView: HeaderRightView?
    let headerStyle: HeaderStyle?

    
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
        self.headerShown = headerShown
        self.headerBackButtonDisplayMode = headerBackButtonDisplayMode
        self.headerBackButtonHidden = headerBackButtonHidden
        
        self.headerLeftView = headerLeftView
        self.headerRightView = headerRightView
        self.headerStyle = headerStyle
        
    }
}



