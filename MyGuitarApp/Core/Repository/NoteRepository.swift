// Core/Repository/NoteRepository.swift

import Foundation

protocol NoteRepository: Sendable {
    func fetchNotes(for scoreId: UUID) async throws -> [Note]
}

