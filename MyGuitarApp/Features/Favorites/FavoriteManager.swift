// Features/Favorites/FavoriteManager.swift
// Favorites 관리

import Foundation
import Combine

final class FavoriteManager: ObservableObject {
    static let shared = FavoriteManager()
    private init() {}

    // Published 매크로 사용: 상태가 바뀌면 자동으로 UI를 업데이트(FavoritesView에서 StateObject 매크로로 구독)
    @Published private(set) var favorites: Set<UUID> = []

    private let key = "favorite_songs"

    // MARK: -LOAD
    func load() {
        if let data = UserDefaults.standard.array(forKey: key) as? [String] {
            favorites = Set(data.compactMap { UUID(uuidString: $0) })
        }
    }

    // MARK: -TOGGLE(ADD, DELETE)
    func toggle(songId: UUID) {
        if favorites.contains(songId) {
            favorites.remove(songId)
        } else {
            favorites.insert(songId)
        }
        save()
    }

    // MARK: -IS_FAVORITE
    func isFavorite(_ id: UUID) -> Bool {
        favorites.contains(id)
    }

    // MARK: -SAVE(앱 로컬 저장: 전역 공유, DB에 추가할 정도로 중요한 데이터는 아님)
    private func save() {
        let ids = favorites.map { $0.uuidString }
        UserDefaults.standard.set(ids, forKey: key)
    }
}
