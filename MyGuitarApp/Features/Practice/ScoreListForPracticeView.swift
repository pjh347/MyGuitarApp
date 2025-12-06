// Features/Practice/ScoreListForPracticeView.swift

import SwiftUI

struct ScoreListForPracticeView: View {
    @State private var scoreVM: ScoreViewModel

    init(song: Song) {
        _scoreVM = State(wrappedValue: ScoreViewModel(song: song))
    }

    var body: some View {
        List {
            ForEach(scoreVM.scores) { score in
                NavigationLink {
                    NoteListView(score: score)
                } label: {
                    VStack(alignment: .leading) {
                        Text(score.version ?? "기본 버전")
                        Text(score.instrument ?? "악기")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .task {
            await scoreVM.loadScores()
        }
    }
}
