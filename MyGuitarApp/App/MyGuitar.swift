// App/MyGuitarApp.swift

import SwiftUI

@main
struct MyGuitarApp: App {
    // SettingsView의 "dark_mode" key 사용 -> SettingsView에서 값이 변하면 UI 랜더링
    @AppStorage("dark_mode") private var darkMode = false

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(darkMode ? .dark : .light)
        }
    }
}


#Preview {
    MainTabView()
}
