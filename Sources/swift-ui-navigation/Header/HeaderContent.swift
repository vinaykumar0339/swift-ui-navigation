//
//  File.swift
//  swift-ui-navigation
//
//  Created by Vinay Kumar on 22/12/25.
//

import Foundation
import SwiftUI

public enum HeaderContent {
    case none
    case items([HeaderItem])
    case custom(AnyView)
}
