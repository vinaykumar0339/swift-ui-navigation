# Swift UI Navigation

A clean, flexible, and type-safe navigation library for SwiftUI, inspired by React Navigation. This library decouples navigation logic from your views, allowing for a more modular and testable architecture.

## Features

- 📱 **Stack Navigation**: Push and pop screens with ease.
- 🗂️ **Tab Navigation**: customizable tab bars and switching.
- 🎨 **Screen Options**: Dynamic configuration for headers, titles, and back buttons.
- 📄 **Sheets & Modals**: Simplified API for presenting sheets and full-screen covers.
- 🧩 **Type-Safe Routes**: Define your navigation structure using Swift enums or structs.
- 🔗 **Decoupled Logic**: Access navigation controllers via property wrappers anywhere in the hierarchy.

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/vinaykumar0339/swift-ui-navigation.git", from: "1.0.0")
]
```

## Usage

### 1. Define Routes

First, define your routes by conforming to the `Route` protocol. Enums are perfect for this.

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

### 2. Stack Navigation

Create a Stack Navigator and define your screens.

```swift
import SwiftUI
import SwiftUINavigation

struct ContentView: View {
    // Create the factory for your specific routes
    let Stack = createStackNavigator(AppRoutes.self)

    var body: some View {
        NavigationContainer {
            Stack.Navigator(initialRoute: .home) {
                
                // Simple Screen
                Stack.Screen(route: .home) { navigation, route in
                    HomeView()
                }

                // Screen with Options
                Stack.Screen(
                    route: .details(id: ""), // Route matching pattern
                    options: ScreenOptions(title: "Details")
                ) { navigation, route in
                    if let id = route.params as? String {
                        DetailsView(id: id)
                    }
                }
                
                // Screen with Dynamic Options
                Stack.Screen(
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

### 3. Navigating Between Screens

You can access the navigation object passed into the screen closure, or use the `@AppStackNavigation` property wrapper inside any child view.

```swift
struct HomeView: View {
    // Access navigation from anywhere in the stack
    @AppStackNavigation<AppRoutes> var navigation

    var body: some View {
        VStack {
            Button("Go to Details") {
                navigation.navigate(to: .details(id: "123"))
            }
        }
    }
}
```

### 4. Tab Navigation

Tab navigation works similarly to Stack navigation.

```swift
struct MainTabView: View {
    let Tab = createTabNavigator(AppRoutes.self)

    var body: some View {
        Tab.Navigator(initialRoute: .home) {
            
            Tab.Screen(
                route: .home,
                options: TabOptions(
                    tabItem: .item(.label(text: "Home", systemImage: "house"))
                )
            ) { navigation, route in
                HomeView()
            }

            Tab.Screen(
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
```

### 5. Customizing Headers (Screen Options)

You can customize the navigation bar using `ScreenOptions`.

```swift
Stack.Screen(
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

### 6. Sheets and Modals

Use `SheetButtonView` or `FullScreenCoverButtonView` to present modals easily.

```swift
struct DetailsView: View {
    var body: some View {
        SheetButtonView(data: "Some Context Data") {
            Text("Open Sheet")
        } content: { context in
            VStack {
                Text("Sheet Content: \(context.item.data)")
                Button("Close") {
                    context.close()
                }
            }
        }
    }
}
```

### 7. Dynamic Header Updates

You can update screen options dynamically from within your view using the `@AppScreenOptionsState` property wrapper. This allows you to change the title, visibility, or header buttons in response to user actions or state changes.

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
                        screenOptions.navigationTitle = "Profile"
                        screenOptions.headerRightView = nil
                    }
                ])
            }
        }
    }
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
