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
    
    private let configuration: SheetConfiguration

    public init(
        data: Data,
        configuration: SheetConfiguration = .init(),
        @ViewBuilder trigger: () -> Trigger,
        @ViewBuilder content: @escaping (SheetContentContext<Data>) -> SheetContent
    ) {
        self.initialData = data
        self.configuration = configuration
        self.trigger = trigger()
        self.content = content
    }

    public var body: some View {
        Button {
            activeSheet = SheetItem(data: initialData)
        } label: {
            trigger
        }
        .sheet(
            item: $activeSheet,
            onDismiss: configuration.onDismiss
        ) { item in
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
            .applySheetConfiguration(configuration)
        }
    }
}

public extension SheetButtonView where Data == Void {
    init(
        configuration: SheetConfiguration = .init(),
        @ViewBuilder trigger: () -> Trigger,
        @ViewBuilder content: @escaping (SheetContentContext<Void>) -> SheetContent
    ) {
        self.initialData = ()
        self.configuration = configuration
        self.trigger = trigger()
        self.content = content
    }
}

