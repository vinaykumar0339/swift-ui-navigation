//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 27/12/25.
//

import Foundation
import SwiftUI

public enum TabBar {
    case custom(() -> AnyView)
    
    func resolve() -> AnyView {
        switch self {
        case .custom(let builder):
            builder()
        }
    }
}
