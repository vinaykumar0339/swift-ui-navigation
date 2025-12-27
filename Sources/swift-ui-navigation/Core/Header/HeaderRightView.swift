//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 25/12/25.
//

import Foundation
import SwiftUI

public struct HeaderRightViewItem {
    let action: () -> Void
    let content: AnyView

    private init(
        action: @escaping () -> Void,
        content: AnyView
    ) {
        self.action = action
        self.content = content
    }
}

extension HeaderRightViewItem {
    public static func icon(
        _ image: Image,
        action: @escaping () -> Void
    ) -> HeaderRightViewItem {
        HeaderRightViewItem(
            action: action,
            content: AnyView(image)
        )
    }

    public static func text(
        _ text: String,
        action: @escaping () -> Void
    ) -> HeaderRightViewItem {
        HeaderRightViewItem(
            action: action,
            content: AnyView(Text(text))
        )
    }

    public static func label(
        text: String,
        systemImage: String,
        action: @escaping () -> Void
    ) -> HeaderRightViewItem {
        HeaderRightViewItem(
            action: action,
            content: AnyView(
                Label(text, systemImage: systemImage)
            )
        )
    }
    
    public static func label(
        text: String,
        image: String,
        action: @escaping () -> Void
    ) -> HeaderRightViewItem {
        HeaderRightViewItem(
            action: action,
            content: AnyView(
                Label(text, image: image)
            )
        )
    }
    
    public static func label(
        title: Text,
        icon: Image,
        action: @escaping () -> Void
    ) -> HeaderRightViewItem {
        HeaderRightViewItem(
            action: action,
            content: AnyView(
                Label(title: {
                    title
                }, icon: {
                    icon
                })
            )
        )
    }

    public static func custom<Content: View>(
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) -> HeaderRightViewItem {
        HeaderRightViewItem(
            action: action,
            content: AnyView(content())
        )
    }
}


public enum HeaderRightView {
    case none
    case items([HeaderRightViewItem])
    case custom(() -> AnyView)
}
