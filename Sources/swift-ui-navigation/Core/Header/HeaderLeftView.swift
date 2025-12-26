//
//  HeaderLeftButtonOption.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 25/12/25.
//


import Foundation
import SwiftUI

public struct HeaderLeftBasicView {
    let image: String?
    let systemImage: String?
    
    let tintColor: Color?
    
    let title: String?
    let subtitle: String?
    let action: (() -> Void)?
    
    public init(
        tintColor: Color? = .primary,
        title: String? = nil,
        subtitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.image = nil
        self.tintColor = tintColor
        self.systemImage = nil
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
    public init(
        image: String? = nil,
        tintColor: Color? = .primary,
        title: String? = nil,
        subtitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.image = image
        self.tintColor = tintColor
        self.systemImage = nil
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
    public init(
        systemImage: String? = nil,
        tintColor: Color? = .primary,
        title: String? = nil,
        subtitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.image = nil
        self.systemImage = systemImage
        self.tintColor = tintColor
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
}

public enum HeaderLeftView {
    case none
    case basic(HeaderLeftBasicView)
    case custom(() -> AnyView)
}
