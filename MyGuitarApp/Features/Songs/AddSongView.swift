// Features/Songs/AddSongView.swift
// 노래 추가 화면

import SwiftUI

struct AddSongView: View {
    // SwiftUI의 dismiss 함수를 지역 변수로 사용
    @Environment(\.dismiss) private var dismiss
    // 부모(SongRootView)로 부터 받은 저장 콜백 함수
    let onSave: (String, String?, Int?, Int?) -> Void

    // 입력 받을 값
    @State private var title: String = ""
    @State private var artist: String = ""
    @State private var bpmText: String = ""
    @State private var difficultyText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                // 기본 정보(제목, 아티스트)는 TextField에 값이 있어야 함.
                Section("기본 정보") {
                    TextField("제목", text: $title)
                    TextField("아티스트", text: $artist)
                }

                // 메타 정보(BPM, 난이도)는 TextField에 값을 쓰지 않아도 됨.(옵션 값)
                Section("메타 정보") {
                    TextField("BPM (옵션)", text: $bpmText)
                        .keyboardType(.numberPad)
                    TextField("난이도 (옵션)", text: $difficultyText)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("곡 추가")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        let bpm = Int(bpmText)
                        let difficulty = Int(difficultyText)
                        onSave(title, artist.isEmpty ? nil : artist, bpm, difficulty)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
