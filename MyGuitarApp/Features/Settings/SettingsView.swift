// SettingsView.swift

import SwiftUI

struct SettingsView: View {
    @AppStorage("dark_mode") private var darkMode = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("화면")) {
                    Toggle("다크 모드", isOn: $darkMode)
                }

                Section(header: Text("정보")) {
                    Text("MyGuitarApp v1.0")
                    Text("개발자: 박준형")
                }
            }
            .navigationTitle("Settings")
        }
    }
}
