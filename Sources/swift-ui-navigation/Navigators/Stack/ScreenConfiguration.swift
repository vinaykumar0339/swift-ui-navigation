//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 22/12/25.
//

import Foundation
import SwiftUI

public struct ScreenConfiguration<Screen: ScreenProtocol> {
    let id = UUID()
    let name: Screen
    let options: ScreenOptions
    let builder: (Route<Screen>, Navigation<Screen>) -> AnyView
}

public struct ScreenProps<Screen: ScreenProtocol, Params> {
    public let navigation: Navigation<Screen>
    public let route: Route<Screen>
    public let params: Params
}
