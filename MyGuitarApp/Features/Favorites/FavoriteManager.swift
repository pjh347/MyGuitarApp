// FavoriteManager.swift

import Foundation
import Combine

final class FavoriteManager: ObservableObject {
    static let shared = FavoriteManager()
    private init() {}

    @Published private(set) var favorites: Set<UUID> = []

    private let key = "favorite_songs"

    func load() {
        if let data = UserDefaults.standard.array(forKey: key) as? [String] {
            favorites = Set(data.compactMap { UUID(uuidString: $0) })
        }
    }

    func toggle(songId: UUID) {
        if favorites.contains(songId) {
            favorites.remove(songId)
        } else {
            favorites.insert(songId)
        }
        save()
    }

    func isFavorite(_ id: UUID) -> Bool {
        favorites.contains(id)
    }

    private func save() {
        let ids = favorites.map { $0.uuidString }
        UserDefaults.standard.set(ids, forKey: key)
    }
}
