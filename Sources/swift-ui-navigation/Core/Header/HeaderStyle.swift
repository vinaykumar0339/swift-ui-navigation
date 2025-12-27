//
//  HeaderStyle.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 25/12/25.
//


import Foundation
import SwiftUI

public struct HeaderStyle {
    public let style: AnyShapeStyle
    public let isVisible: Bool

    public init<S> (
        _ style: S,
        isVisible: Bool = true
    )  where S: ShapeStyle {
        self.style = AnyShapeStyle(style)
        self.isVisible = isVisible
    }
}
