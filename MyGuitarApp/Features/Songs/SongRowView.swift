// SongRowView.swift
// SongRowView: 단순 List 출력 -> 카드로 출력 예정

import SwiftUI

struct SongRowView: View {
    let song: Song
    
    @StateObject private var previewModel: SongPreviewModel
    
    init(song: Song) {
        self.song = song
        _previewModel = StateObject(wrappedValue: SongPreviewModel(song: song))
    }

    private var instrumentEmoji: String { "🎸" }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 제목 + 악기 이모지
            HStack {
                Text(song.title)
                    .font(.headline)
                Spacer()
                Text(instrumentEmoji)
                    .font(.title2)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.gray.opacity(0.3), lineWidth: 1)
                    .frame(height: 80)

                if previewModel.previewNotes.isEmpty {
                    Text("악보 미리보기 없음")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    MiniGuitarTabView(notes: previewModel.previewNotes)
                        .clipped()
                }
            }
            
            // artist, bpm, difficulty 등 메타 정보
            HStack {
                Text(song.artist ?? "Unknown Artist")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let bpm = song.bpm {
                    Text("\(bpm) bpm")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let difficulty = song.difficulty {
                    Text("Lv.\(difficulty)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black.opacity(0.05), lineWidth: 0.5)
        )
        .padding(.vertical, 4)
        
        .task {
            await previewModel.loadPreview()
        }
    }
}
