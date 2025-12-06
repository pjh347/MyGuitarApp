// Features/Settings/SettingsView.swift

import SwiftUI

struct SettingsView: View {
    // 다크모드 설정, AppStorage 매크로: UserDefaults + Swift 자동화 = 값을 저장하면 UserDefaults에 자동 저장, 값이 바뀌면 Swift UI가 자동 랜더링
    @AppStorage("dark_mode") private var darkMode = false // "dark_mode" key 사용 -> dark_mode의 값이 변하면 MyGuitar.swift에서 UI 랜더링

    var body: some View {
        NavigationStack {
            Form {
                // Toggle 버튼으로 구현
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
