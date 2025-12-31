//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 25/12/25.
//

import Foundation
import SwiftUI

// MARK: - FullScreenCoverButtonView
public struct FullScreenCoverButtonView<
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
        .fullScreenCover(item: $activeSheet) { item in
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

public extension FullScreenCoverButtonView where Data == Void {
    
    init (
        @ViewBuilder trigger: () -> Trigger,
        @ViewBuilder content: @escaping (SheetContentContext<Void>) -> SheetContent
    ) {
        self.initialData = ()
        self.trigger = trigger()
        self.content = content
    }
    
}

