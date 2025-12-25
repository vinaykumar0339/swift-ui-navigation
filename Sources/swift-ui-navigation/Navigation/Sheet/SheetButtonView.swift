//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 25/12/25.
//

import Foundation
import SwiftUI

// MARK: - SheetButtonView
public struct SheetButtonView<
    Trigger: View,
    SheetContent: View,
    Data
>: View {

    private let trigger: Trigger
    private let initialData: Data
    private let content: (SheetContentContext<Data>) -> SheetContent

    @State private var activeSheet: SheetItem<Data>?

    public init(
        data: Data,
        @ViewBuilder trigger: () -> Trigger,
        @ViewBuilder content: @escaping (SheetContentContext<Data>) -> SheetContent
    ) {
        self.initialData = data
        self.trigger = trigger()
        self.content = content
    }

    public var body: some View {
        Button {
            activeSheet = SheetItem(data: initialData)
        } label: {
            trigger
        }
        .sheet(item: $activeSheet) { item in
            content((
                item: item,
                isPresenting: true,
                close: {
                    activeSheet = nil
                },
                replace: { newData in
                    activeSheet = SheetItem(data: newData)
                }
            ))
        }
    }
}

