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


public struct SheetConfiguration {
    
    public var detents: Set<PresentationDetent>
    public var selectedDetent: Binding<PresentationDetent>?
    public var showsDragIndicator: Bool
    public var isDismissible: Bool
    
    public var onDismiss: (() -> Void)?
    
    public init(
        detents: Set<PresentationDetent> = [.large],
        selectedDetent: Binding<PresentationDetent>? = nil,
        showsDragIndicator: Bool = true,
        isDismissible: Bool = true,
        onDismiss: (() -> Void)? = nil
    ) {
        self.detents = detents
        self.selectedDetent = selectedDetent
        self.showsDragIndicator = showsDragIndicator
        self.isDismissible = isDismissible
        self.onDismiss = onDismiss
    }
}

extension View {
    
    @ViewBuilder
    func applySheetConfiguration(
        _ configuration: SheetConfiguration
    ) -> some View {
        self
            .ifLet(configuration.selectedDetent) { view, selectedDetent in
                view.presentationDetents(configuration.detents, selection: selectedDetent)
            }
            .presentationDetents(configuration.detents)
            .presentationDragIndicator(configuration.showsDragIndicator ? .visible : .hidden)
            .interactiveDismissDisabled(!configuration.isDismissible)
    }
    
    @ViewBuilder
    func ifLet<T, Content: View>(
        _ value: T?,
        transform: (Self, T) -> Content
    ) -> some View {
        if let value {
            transform(self, value)
        } else {
            self
        }
    }
    
}

