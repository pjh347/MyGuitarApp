// SongRowView.swift
// SongRowView: 단순 List 출력 -> 카드로 출력 예정

import SwiftUI

struct SongRowView: View {
    let song: Song
    
    // 나중에 Score의 instrument로 바꿀 예정
    private var instrumentEmoji: String {
        "🎸"
    }
    
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
            
            // 미리보기 자리
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.gray.opacity(0.3), lineWidth: 1)
                    .frame(height: 80)
                
                Text("악보 미리보기")
                    .font(.caption)
                    .foregroundColor(.gray)
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
    }
}
