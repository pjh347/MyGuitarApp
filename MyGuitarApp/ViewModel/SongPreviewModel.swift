//  SongPreviewViewModel.swift

import Foundation
import SwiftUI
import Combine

@MainActor
final class SongPreviewModel: ObservableObject {
    @Published var previewNotes: [Note] = []

    private let song: Song
    private let scoreRepo: ScoreRepository
    private let noteRepo: NoteRepository

    init(song: Song,
         scoreRepo: ScoreRepository = SupabaseScoreRepository(),
         noteRepo: NoteRepository = SupabaseNoteRepository()) {
        self.song = song
        self.scoreRepo = scoreRepo
        self.noteRepo = noteRepo
    }

    func loadPreview() async {
        do {
            let scores = try await scoreRepo.fetchScores(for: song.id)
            guard let firstScore = scores.first else { return }
            let notes = try await noteRepo.fetchNotes(for: firstScore.id)
            previewNotes = Array(notes.prefix(16))
        } catch {
            print("❌ preview load error:", error)
        }
    }
}
