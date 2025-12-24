import Foundation
import SwiftUI

@MainActor
public struct Navigation<R: Route> {
    private let navigation: AnyNavigation

    init(_ navigation: AnyNavigation) {
        self.navigation = navigation
    }

    public func navigate(to route: R) {
        navigation.navigate(to: route)
    }
    
    public func pop() {
        navigation.pop()
    }
    
    public func popToTop() {
        navigation.popToTop()
    }

    public func goBack() {
        navigation.goBack()
    }
    
    public var canGoBack: Bool {
        navigation.canGoBack()
    }
}