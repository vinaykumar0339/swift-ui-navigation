//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 22/12/25.
//

import Foundation
import SwiftUI

public enum Stack {
    
    @MainActor
    public static func Screen<R: Route, Content: View>(
        options: NavigationOptions = .default,
        @ViewBuilder _ builder: @escaping (R) -> Content
    ) -> some View {
        swift_ui_navigation.Screen(options: options, builder: builder)
    }
    
}
