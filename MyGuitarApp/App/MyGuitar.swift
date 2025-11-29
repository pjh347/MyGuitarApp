// MyGuitarApp.swift

import SwiftUI

@main
struct MyGuitarApp: App {
    @AppStorage("dark_mode") private var darkMode = false

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(darkMode ? .dark : .light)
        }
    }
}

