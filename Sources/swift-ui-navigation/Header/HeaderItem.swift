//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 22/12/25.
//

import Foundation
import SwiftUI

public struct HeaderItem: Identifiable {
    public let id = UUID()
    public let placement: ToolbarItemPlacement
    let view: AnyView
    
    private init(placement: ToolbarItemPlacement, view: AnyView) {
        self.placement = placement
        self.view = view
    }
}

public extension HeaderItem {
    
    static func icon(
        _ systemImage: String,
        placement: ToolbarItemPlacement = .topBarTrailing,
        action: @escaping () -> Void
    ) -> HeaderItem {
        HeaderItem(placement: placement, view: AnyView(
            Button(action: action, label: {
                Image(systemName: systemImage)
            })
        ))
    }
    
    static func text(
        _ title: String,
        placement: ToolbarItemPlacement = .topBarLeading,
        action: @escaping () -> Void
    ) -> HeaderItem {
        HeaderItem(placement: placement, view: AnyView(
            Button(title, action: action)
        ))
    }
    
    static func custom<V: View>(
        placement: ToolbarItemPlacement = .topBarTrailing,
        @ViewBuilder content: () -> V
    ) -> HeaderItem {
        HeaderItem(placement: placement, view: AnyView(content()))
    }
    
}
