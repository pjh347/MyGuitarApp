// ScoreViewModel.swift

import SwiftUI

@MainActor
@Observable
final class ScoreViewModel {
    let song: Song
    private let repository: ScoreRepository

    init(song: Song,
         repository: ScoreRepository = SupabaseScoreRepository()) {
        self.song = song
        self.repository = repository
    }

    private var _scores: [Score] = []
    var scores: [Score] { _scores }

    // MARK: -LOAD
    func loadScores() async {
        do {
            _scores = try await repository.fetchScores(for: song.id)
        } catch {
            print("❌ loadScores error:", error)
        }
    }

    // MARK: -ADD
    func addScore(version: String?, instrument: String?) async {
        let newScore = Score(
            id: UUID(),
            songId: song.id,
            version: version,
            instrument: instrument,
            createdAt: nil
        )

        do {
            let created = try await repository.addScore(newScore)
            _scores.append(created)
        } catch {
            print("❌ addScore error:", error)
        }
    }

    // MARK: -DELETE
    func deleteScore(at offsets: IndexSet) async {
        for index in offsets {
            let score = _scores[index]
            do {
                try await repository.deleteScore(id: score.id)
                _scores.remove(at: index)
            } catch {
                print("❌ deleteScore error:", error)
            }
        }
    }
}
