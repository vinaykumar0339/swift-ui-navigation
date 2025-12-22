//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 22/12/25.
//

import Foundation

@resultBuilder
public struct ScreenBuilder<Screen: ScreenProtocol> {
    public static func buildBlock(_ components: ScreenConfiguration<Screen>...) -> [ScreenConfiguration<Screen>] {
        components
    }
    
    public static func buildArray(_ components: [[ScreenConfiguration<Screen>]]) -> [ScreenConfiguration<Screen>] {
        components.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [ScreenConfiguration<Screen>]?) -> [ScreenConfiguration<Screen>] {
        component ?? []
    }
}
