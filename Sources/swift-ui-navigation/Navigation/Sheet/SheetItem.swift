//
//  SheetItem.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 25/12/25.
//


import Foundation
import SwiftUI

public struct SheetItem<Data>: Identifiable {
    public let id = UUID()
    public let data: Data

    public init(data: Data) {
        self.data = data
    }
}

public typealias SheetContentContext<Data> =
(
    item: SheetItem<Data>,
    isPresenting: Bool,
    close: () -> Void,
    replace: (Data) -> Void
)
