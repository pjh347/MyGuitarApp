// ScoreView.swift

import SwiftUI

struct ScoreView: View {
    @State private var viewModel: ScoreViewModel
    
    init(song: Song) {
        _viewModel = State(initialValue: ScoreViewModel(song: song))
    }
    
    var body: some View {
        List {
            Section("악보 버전") {
                ForEach(viewModel.scores) { score in
                    NavigationLink {
                        NoteListView(score: score)
                    } label: {
                        HStack {
                            Text(score.instrument ?? "🎵")
                            Text(score.version ?? "default")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.song.title)
        .task {
            await viewModel.loadScores()
        }
    }
}
