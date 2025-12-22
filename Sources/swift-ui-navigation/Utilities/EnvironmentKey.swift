//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 22/12/25.
//

import Foundation
import SwiftUI

private struct CurrentRouteKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Any? = nil
}

extension EnvironmentValues {
    var currentRoute: Any? {
        get { self[CurrentRouteKey.self] }
        set { self[CurrentRouteKey.self] = newValue }
    }
}
