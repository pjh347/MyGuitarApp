// SongViewModel.swift

import SwiftUI

@MainActor
@Observable
final class SongViewModel {
    private let repository: SongRepository

    init(repository: SongRepository = SupabaseSongRepository()) {
        self.repository = repository
    }

    private var _songs: [Song] = []
    var songs: [Song] { _songs }

    // MARK: -LOAD
    func loadSongs() async {
        do {
            _songs = try await repository.fetchSongs()
        } catch {
            print("❌ loadSongs error:", error)
        }
    }

    // MARK: -ADD
    func addSong(title: String,
                 artist: String?,
                 bpm: Int?,
                 difficulty: Int?) async {
        let newSong = Song(
            id: UUID(),
            title: title,
            artist: artist,
            bpm: bpm,
            difficulty: difficulty,
            createdAt: nil
        )

        do {
            let created = try await repository.addSong(newSong)
            _songs.append(created)
        } catch {
            print("❌ addSong error:", error)
        }
    }

    // MARK: -DELETE
    func deleteSong(at offsets: IndexSet) async {
        for index in offsets {
            let song = _songs[index]
            do {
                try await repository.deleteSong(id: song.id)
                _songs.remove(at: index)
            } catch {
                print("❌ deleteSong error:", error)
            }
        }
    }
}
