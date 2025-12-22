//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 22/12/25.
//

import Foundation

public struct NavigationOptions {
    
    public var title: String?
    public var headerShown: Bool
    public var headerLeft: HeaderContent
    public var headerRight: HeaderContent
    
    public init(
        title: String? = nil,
        headerShown: Bool = true,
        headerLeft: HeaderContent = .none,
        headerRight: HeaderContent = .none
    ) {
        self.title = title
        self.headerShown = headerShown
        self.headerLeft = headerLeft
        self.headerRight = headerRight
    }
    
    public static var `default`: NavigationOptions {
        NavigationOptions()
    }
    
}
