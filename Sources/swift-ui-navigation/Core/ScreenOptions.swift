//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 22/12/25.
//

import Foundation
import SwiftUI

public struct ScreenOptions {
    public var title: String?
    public var headerShown: Bool
    public var headerBackTitle: String?
    public var headerStyle: HeaderStyle?
    public var headerTitleStyle: HeaderTitleStyle?
    public var presentation: PresentationStyle?
    
    public init(
        title: String? = nil,
        headerShown: Bool = true,
        headerBackTitle: String? = nil,
        headerStyle: HeaderStyle? = nil,
        headerTitleStyle: HeaderTitleStyle? = nil,
        presentation: PresentationStyle? = nil
    ) {
        self.title = title
        self.headerShown = headerShown
        self.headerBackTitle = headerBackTitle
        self.headerStyle = headerStyle
        self.headerTitleStyle = headerTitleStyle
        self.presentation = presentation
    }
    
    public static var `default`: ScreenOptions {
        ScreenOptions()
    }
}

public struct HeaderStyle {
    public var backgroundColor: Color?
    
    public init(backgroundColor: Color? = nil) {
        self.backgroundColor = backgroundColor
    }
}

public struct HeaderTitleStyle {
    public var color: Color?
    public var font: Font?
    
    public init(color: Color? = nil, font: Font? = nil) {
        self.color = color
        self.font = font
    }
}

public enum PresentationStyle {
    case push
    case modal
    case fullScreenModal
}
