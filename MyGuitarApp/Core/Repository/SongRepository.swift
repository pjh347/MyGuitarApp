// SongRepository.swift

import Foundation

// CRUD: UPDATE 추가 예정
protocol SongRepository: Sendable {
    func fetchSongs() async throws -> [Song]
    func addSong(_ song: Song) async throws -> Song
    func deleteSong(id: UUID) async throws
}
