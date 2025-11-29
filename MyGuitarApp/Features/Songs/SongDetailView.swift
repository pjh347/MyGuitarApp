// SongDetailView.swift

import SwiftUI

struct SongDetailView: View {
    let song: Song
    @State private var scoreViewModel: ScoreViewModel
    @StateObject private var favorites = FavoriteManager.shared

    init(song: Song) {
        self.song = song
        _scoreViewModel = State(initialValue: ScoreViewModel(song: song))
    }

    var body: some View {
        List {
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

            ScoreSectionView(
                scores: scoreViewModel.scores,
                onAdd: { version, instrument in
                    Task {
                        await scoreViewModel.addScore(version: version, instrument: instrument)
                    }
                },
                onDelete: { offsets in
                    Task {
                        await scoreViewModel.deleteScore(at: offsets)
                    }
                }
            )
        }
        .navigationTitle(song.title)
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
