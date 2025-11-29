// AddSongView.swift

import SwiftUI

struct AddSongView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (String, String?, Int?, Int?) -> Void

    @State private var title: String = ""
    @State private var artist: String = ""
    @State private var bpmText: String = ""
    @State private var difficultyText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("기본 정보") {
                    TextField("제목", text: $title)
                    TextField("아티스트", text: $artist)
                }

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
