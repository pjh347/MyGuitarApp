// SongRootView.swift

import SwiftUI

@MainActor
struct SongsRootView: View {
    @State private var viewModel = SongViewModel()
    @State private var showingAddSong = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.songs) { song in
                    NavigationLink {
                        SongDetailView(song: song)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .font(.headline)
                            Text(song.artist ?? "Unknown Artist")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete { offsets in
                    Task {
                        await viewModel.deleteSong(at: offsets)
                    }
                }
            }
            .navigationTitle("Songs")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSong = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSong) {
                AddSongView { title, artist, bpm, difficulty in
                    Task {
                        await viewModel.addSong(
                            title: title,
                            artist: artist,
                            bpm: bpm,
                            difficulty: difficulty
                        )
                        await viewModel.loadSongs()
                    }
                }
            }
            .task {
                await viewModel.loadSongs()
            }
            .refreshable {
                await viewModel.loadSongs()
            }
        }
    }
}
