// ScoreRepository.swift

import Foundation

protocol ScoreRepository: Sendable {
    func fetchScores(for songId: UUID) async throws -> [Score]
    func addScore(_ score: Score) async throws -> Score
    func deleteScore(id: UUID) async throws
}
