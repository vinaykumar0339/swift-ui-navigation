//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 24/12/25.
//

import Foundation

public struct ScreenOptions {
    let title: String? // fallback to the route name itself
    
    public init(title: String?) {
        self.title = title
    }
}
