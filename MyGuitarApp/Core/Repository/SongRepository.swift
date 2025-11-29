// SongRepository.swift

import Foundation

protocol SongRepository: Sendable {
    func fetchSongs() async throws -> [Song]
    func addSong(_ song: Song) async throws -> Song
    func deleteSong(id: UUID) async throws
}
