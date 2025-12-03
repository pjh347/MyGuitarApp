// FavoritesView.swift
// FavoritesView(즐겨찾기 TabView)

import SwiftUI

struct FavoritesView: View {
    // favorites 구독(@Published 매크로 -> @StateObject 구독: 상태가 바뀌면 자동으로 UI 업데이트)
    @StateObject private var favorites = FavoriteManager.shared
    @State private var viewModel = SongViewModel()

    var body: some View {
        NavigationStack {
            List {
                // isFavorite filter로 favorites 리스트 가져옴
                ForEach(viewModel.songs.filter { favorites.isFavorite($0.id) }) { song in
                    // NavigationLink로 Favorite TabView에서 아이템을 선택하면 DetailView로 넘어가도록
                    NavigationLink {
                        SongDetailView(song: song)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .font(.headline)
                            if let artist = song.artist {
                                Text(artist)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .task {
                favorites.load()
                await viewModel.loadSongs()
            }
        }
    }
}
