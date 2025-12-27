//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 27/12/25.
//

import Foundation
import SwiftUI

public struct TabBasicViewItem {
    let content: AnyView
    
    private init(_ content: AnyView) {
        self.content = content
    }
}

extension TabBasicViewItem {
    
    public static func icon(
        _ image: Image
    ) -> TabBasicViewItem {
        .init(AnyView(image))
    }
    
    public static func text(
        _ text: String
    ) -> TabBasicViewItem {
        .init(AnyView(Text(text)))
    }
    
    public static func label(
        text: String,
        systemImage: String
    ) -> TabBasicViewItem {
        .init(AnyView(Label(text, systemImage: systemImage)))
    }
    
    public static func label(
        text: String,
        image: String
    ) -> TabBasicViewItem {
        .init(AnyView(Label(text, image: image)))
    }
    
    public static func label(
        title: Text,
        icon: Image
    ) -> TabBasicViewItem {
        .init(AnyView(
            Label(title: {
                title
            }, icon: {
                icon
            })
        ))
    }
    
    public static func custom<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> TabBasicViewItem {
        .init(AnyView(content()))
    }
    
}

public enum TabItem {
    case item(TabBasicViewItem)
    case custom(() -> AnyView)
    
    func resolve() -> AnyView {
        switch self {
        case .item(let item):
            return item.content
        case .custom(let content):
            return content()
        }
    }
}
