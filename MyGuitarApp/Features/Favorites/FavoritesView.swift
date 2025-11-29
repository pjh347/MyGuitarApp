// FavoritesView.swift

import SwiftUI

struct FavoritesView: View {
    @StateObject private var favorites = FavoriteManager.shared
    @State private var viewModel = SongViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.songs.filter { favorites.isFavorite($0.id) }) { song in
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
