//  NoteViewModel.swift.swift

import Foundation
import SwiftUI
import Combine

@MainActor
final class NoteViewModel: ObservableObject {
    @Published var notes: [Note] = []

    let score: Score
    private let repository: NoteRepository

    init(score: Score,
         repository: NoteRepository = SupabaseNoteRepository()) {
        self.score = score
        self.repository = repository
    }

    func loadNotes() async {
        do {
            notes = try await repository.fetchNotes(for: score.id)
        } catch {
            print("❌ loadNotes error:", error)
        }
    }
}
