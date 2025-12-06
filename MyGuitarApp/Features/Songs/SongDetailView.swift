// Features/Songs/SongDetailView.swift
// SongsTabView에서 song을 선택할 경우 출력되는 view

import SwiftUI

struct SongDetailView: View {
    let song: Song
    @State private var scoreViewModel: ScoreViewModel
    // favorites 구독(@Published 매크로 -> @StateObject 구독: 상태가 바뀌면 자동으로 UI 업데이트)
    @StateObject private var favorites = FavoriteManager.shared

    init(song: Song) {
        self.song = song
        _scoreViewModel = State(initialValue: ScoreViewModel(song: song))
    }

    var body: some View {
        List {
            // MARK: -INFO_SONG
            Section("곡 정보") {
                Text(song.title)
                    .font(.headline)
                if let artist = song.artist {
                    Text(artist)
                        .foregroundColor(.secondary)
                }
                if let bpm = song.bpm {
                    Text("BPM: \(bpm)")
                }
                if let diff = song.difficulty {
                    Text("난이도: \(diff)")
                }
            }

            // MARK: -SCORE_SECTION
            ScoreSectionView(
                scores: scoreViewModel.scores,
                // onAdd 구현체 (scoreViewModel이 처리)
                onAdd: { version, instrument in
                    Task {
                        await scoreViewModel.addScore(version: version, instrument: instrument)
                    }
                },
                // onDelete 구현체 (scoreViewModel이 처리)
                onDelete: { offsets in
                    Task {
                        await scoreViewModel.deleteScore(at: offsets)
                    }
                }
            )
        }
        .navigationTitle(song.title)
        // MARK: -FAVORITE_TOOLBAR
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favorites.toggle(songId: song.id)
                } label: {
                    Image(systemName: favorites.isFavorite(song.id) ? "star.fill" : "star")
                }
            }
        }
        .task {
            await scoreViewModel.loadScores()
        }
    }
}
