# Swift UI Navigation

A clean, flexible, and type-safe navigation library for SwiftUI, inspired by React Navigation. This library decouples navigation logic from your views, allowing for a more modular and testable architecture.

## Features

- 📱 **Stack Navigation**: Push and pop screens with ease using a stack-based history.
- 🗂️ **Tab Navigation**: Customizable tab bars with support for custom views and styles.
- 🎨 **Screen Options**: Dynamic configuration for headers, titles, and back buttons.
- 📄 **Sheets & Modals**: Simplified API for presenting sheets and full-screen covers with data context.
- 🧩 **Type-Safe Routes**: Define your navigation structure using Swift enums
- 🔗 **Decoupled Logic**: Access navigation controllers via property wrappers (`@AppStackNavigator`, `@AppTabNavigator`) anywhere in the view hierarchy.

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/vinaykumar0339/swift-ui-navigation.git", from: "1.0.0")
]
```

## Usage

### 1. Define Routes

Define your routes by conforming to the `Route` protocol. Enums with associated values are ideal for handling parameters.

```swift
import SwiftUINavigation

enum AppRoutes: Route {
    case home
    case details(id: String)
    case settings

    var name: String {
        switch self {
        case .home: return "Home"
        case .details: return "Details"
        case .settings: return "Settings"
        }
    }

    var params: any RouteParams {
        switch self {
        case .details(let id): return id
        default: return EmptyParams()
        }
    }
}
```

### 2. Creating the Navigator

You can define the navigator factory in different scopes. Since the factory is stateless, you can define it globally or as a static property to avoid recreation.

**Option A: Global Variable**
Accessible anywhere in the module.
```swift
@MainActor let Stack = createStackNavigator(AppRoutes.self)
```

**Option B: Static Property on Route Enum**
Keeps the navigator grouped with its routes.
```swift
extension AppRoutes {
    @MainActor static let Stack = createStackNavigator(AppRoutes.self)
}
```

**Option C: Static Property in View**
Scopes the navigator to the specific view.
```swift
struct ContentView: View {
    private static let Stack = createStackNavigator(AppRoutes.self)
    // ...
}
```

### 3. Navigation Container

The `NavigationContainer` is essential as it initializes the navigation environment. It manages the root navigation state and allows child navigators and property wrappers to function correctly. You must wrap your top-level navigator within this container.

```swift
NavigationContainer {
    // Your top-level navigator (Stack or Tab)
}
```

### 4. Stack Navigation

Create a Stack Navigator factory and define your screens within a `NavigationContainer`.

```swift
import SwiftUI
import SwiftUINavigation

struct ContentView: View {
    // Using Option C (Static Property in View)
    private static let Stack = createStackNavigator(AppRoutes.self)

    var body: some View {
        NavigationContainer {
            Self.Stack.Navigator(initialRoute: .home) {
                
                // Simple Screen
                Self.Stack.Screen(route: .home) { navigation, route in
                    HomeView()
                }

                // Screen with Options
                Self.Stack.Screen(
                    route: .details(id: ""), // Route matching pattern. This is just a placeholder to make compiler happy for type-safety.
                    options: ScreenOptions(title: "Details")
                ) { navigation, route in
                    if let id = route.params as? String {
                        DetailsView(id: id)
                    }
                }
                
                // Screen with Dynamic Options based on route/navigation
                Self.Stack.Screen(
                    route: .settings,
                    options: { navigation, route in
                        ScreenOptions(title: "Settings", headerBackButtonDisplayMode: .inline)
                    }
                ) { navigation, route in
                    SettingsView()
                }
            }
        }
    }
}
```

### 5. Navigating Between Screens

Use the `@AppStackNavigator` property wrapper to access the navigation controller from any view within the stack.

The property wrapper uses the generic type (e.g., `AppRoutes`) to resolve the correct navigator. It traverses up the navigation hierarchy to find the nearest parent navigator that handles the specified `Routes` type. If no matching navigator is found in the environment, it will trigger a fatal error:

> `No StackNavigation<AppRoutes> found in environment. Make sure that AppStackNavigator used inside the view of NavigationContainer where you have registered your view.`

```swift
struct HomeView: View {
    // Access navigation from anywhere in the stack
    @AppStackNavigator<AppRoutes> var navigation

    var body: some View {
        VStack {
            Button("Go to Details") {
                navigation.navigate(to: .details(id: "123"))
            }
        }
    }
}
```

### 6. Tab Navigation

Tab navigation follows a similar pattern using `createTabNavigator`.

```swift
struct MainTabView: View {
    private static let Tab = createTabNavigator(AppRoutes.self)

    var body: some View {
        Self.Tab.Navigator(initialRoute: .home) {
            
            Self.Tab.Screen(
                route: .home,
                options: TabOptions(
                    tabItem: .item(.label(text: "Home", systemImage: "house"))
                )
            ) { navigation, route in
                HomeView()
            }

            Self.Tab.Screen(
                route: .settings,
                options: TabOptions(
                    tabItem: .item(.label(text: "Settings", systemImage: "gear"))
                )
            ) { navigation, route in
                SettingsView()
            }
        }
    }
}

### 7. Switching Tabs Programmatically

Use the `@AppTabNavigator` property wrapper to access the tab controller from any view within the tab hierarchy. This allows you to switch tabs programmatically.

It works similarly to `@AppStackNavigator`, resolving the nearest parent tab navigator that matches the generic `Route` type. If no matching navigator is found, it triggers a fatal error:

> `No TabNavigation<AppRoutes> found in environment. Make sure that AppTabNavigator used inside the view of NavigationContainer where you have registered your view.`

```swift
struct SettingsView: View {
    @AppTabNavigator<AppRoutes> var tabNavigation

    var body: some View {
        Button("Go to Home") {
            tabNavigation.navigate(to: .home)
        }
    }
}
```

### 8. Customizing Headers (Screen Options)

Customize the navigation bar appearance and behavior using `ScreenOptions`.

```swift
Self.Stack.Screen(
    route: .home,
    options: ScreenOptions(
        title: "My App",
        headerRightView: .items([
            .icon(Image(systemName: "bell")) {
                print("Notification tapped")
            }
        ]),
        headerStyle: HeaderStyle(.ultraThinMaterial)
    )
) { ... }
```

### 9. Dynamic Header Updates

Update screen options dynamically from within your view using the `@AppScreenOptionsState` property wrapper.

```swift
struct ProfileView: View {
    @AppScreenOptionsState var screenOptions

    var body: some View {
        VStack {
            Text("Profile")
            Button("Edit Mode") {
                screenOptions.navigationTitle = "Editing Profile"
                screenOptions.headerRightView = .items([
                    .text("Done") {
                        // Revert changes
                        screenOptions.navigationTitle = "Profile"
                        screenOptions.headerRightView = nil
                    }
                ])
            }
        }
    }
}
```

### 10. Sheets and Modals

The library provides convenient wrappers for presenting sheets and full-screen covers. These wrappers handle the state management for you and provide a context for closing the sheet or replacing the data.

#### SheetButtonView

Use `SheetButtonView` to present a standard sheet. You can pass data and configuration options (like detents).

```swift
struct DetailsView: View {
    var body: some View {
        // With Data and Configuration
        SheetButtonView(
            data: "Context Data",
            configuration: SheetConfiguration(detents: [.medium, .large])
        ) {
            Text("Open Sheet")
        } content: { context in
            VStack {
                Text("Data: \(context.item.data)")
                Button("Close") { context.close() }
            }
        }
        
        // Simple (No Data)
        SheetButtonView {
            Text("Open Simple Sheet")
        } content: { context in
            Text("Hello")
        }
    }
}
```

#### FullScreenCoverButtonView

Use `FullScreenCoverButtonView` for full-screen presentations.

```swift
struct FullScreenView: View {
    var body: some View {
        FullScreenCoverButtonView {
            Text("Open Full Screen")
        } content: { context in
            VStack {
                Text("Full Screen")
                Button("Dismiss") { context.close() }
            }
        }
    }
}
```

### 11. Complex Example: Nested Navigation (Stack inside Tab)

A common requirement is to have a Stack Navigator running inside a specific Tab. This allows the user to navigate deep into a hierarchy within one tab, switch tabs, and return to find their state preserved.

#### 1. Define Routes

Define separate routes for the Tab Navigator and the nested Stack Navigator.

```swift
// 1. Tab Routes
enum MainTabRoutes: Route {
    case homeStack
    case profile
    
    var name: String {
        switch self {
        case .homeStack: return "HomeStack"
        case .profile: return "Profile"
        }
    }
    var params: any RouteParams { EmptyParams() }
}

// 2. Home Stack Routes
enum HomeStackRoutes: Route {
    case feed
    case details(id: Int)
    
    var name: String {
        switch self {
        case .feed: return "Feed"
        case .details: return "Details"
        }
    }
    var params: any RouteParams {
        switch self {
        case .details(let id): return id
        default: return EmptyParams()
        }
    }
}
```

#### 2. Create Navigators

```swift
extension MainTabRoutes {
    @MainActor static let Tab = createTabNavigator(MainTabRoutes.self)
}

extension HomeStackRoutes {
    @MainActor static let Stack = createStackNavigator(HomeStackRoutes.self)
}
```

#### 3. The Nested Stack View

Create a view that contains the Stack Navigator. This will be the content of one of the tabs.

```swift
struct HomeStackView: View {
    var body: some View {
        // No NavigationContainer needed here, it inherits from the root
        HomeStackRoutes.Stack.Navigator(initialRoute: .feed) {
            
            HomeStackRoutes.Stack.Screen(route: .feed) { navigation, _ in
                VStack {
                    Text("Feed")
                    Button("Go to Details") {
                        navigation.navigate(to: .details(id: 1))
                    }
                }
                .navigationTitle("Feed")
            }
            
            HomeStackRoutes.Stack.Screen(route: .details(id: 0)) { _, route in
                if let id = route.params as? Int {
                    Text("Details #\(id)")
                }
            }
        }
    }
}
```

#### 4. The Root Tab View

Wrap everything in the `NavigationContainer` at the root level.

```swift
struct RootView: View {
    var body: some View {
        NavigationContainer {
            MainTabRoutes.Tab.Navigator(initialRoute: .homeStack) {
                
                // Tab 1: Contains the nested Stack
                MainTabRoutes.Tab.Screen(
                    route: .homeStack,
                    options: TabOptions(
                        tabItem: .item(.label(text: "Home", systemImage: "house"))
                    )
                ) { _, _ in
                    HomeStackView()
                }
                
                // Tab 2: Simple View
                MainTabRoutes.Tab.Screen(
                    route: .profile,
                    options: TabOptions(
                        tabItem: .item(.label(text: "Profile", systemImage: "person"))
                    )
                ) { _, _ in
                    Text("Profile")
                }
            }
        }
    }
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
