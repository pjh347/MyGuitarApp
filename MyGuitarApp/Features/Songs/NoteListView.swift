// NoteListView.swift
// 음표 출력 화면 (이후 연결 예정)

import SwiftUI
import Foundation

struct NoteListView: View {
    let score: Score
    @State private var notes: [Note] = []
    
    var body: some View {
        List(notes.sorted { $0.orderIndex < $1.orderIndex }) { note in
            HStack {
                Text("#\(note.orderIndex)")
                    .font(.caption)
                    .frame(width: 40, alignment: .leading)
                
                VStack(alignment: .leading) {
                    Text("MIDI: \(note.pitchMidi)")
                    if let stringNum = note.stringNum, let fret = note.fret {
                        Text("String \(stringNum), Fret \(fret)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(String(format: "%.3f s", note.startTime))
                        .font(.caption2)
                    Text(String(format: "dur %.3f", note.duration))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("악보 음표")
        .task {
            await loadNotes()
        }
    }
    
    private func loadNotes() async {
        do {
            var request = URLRequest(url: SongApiConfig.notesURL(forScoreId: score.id))
            request.httpMethod = "GET"
            request.setValue(SongApiConfig.apiKey, forHTTPHeaderField: "apikey")
            request.setValue("Bearer \(SongApiConfig.apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            notes = try decoder.decode([Note].self, from: data)
        } catch {
            print("❌ loadNotes error:", error)
        }
    }
}
