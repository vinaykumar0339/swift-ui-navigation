//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 22/12/25.
//

import Foundation
import SwiftUI

public struct Screen<R: Route, Content: View>: View {
    
    private let options: NavigationOptions
    private let builder: (R) -> Content
    
    init(
        options: NavigationOptions = .default,
        builder: @escaping (R) -> Content
    ) {
        self.options = options
        self.builder = builder
    }
    
    public var body: some View {
        EmptyView()
            .navigationDestination(for: R.self) { route in
                builder(route)
                    .navigationTitle(options.title ?? "")
                    .toolbar(options.headerShown ? .visible : .hidden, for: .navigationBar)
                    .toolbar {
                        // TODO: Here need to handle render Header Options later
                    }
            }
    }
}
