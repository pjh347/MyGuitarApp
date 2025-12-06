// SongRootView.swift
// Songs TabView

import SwiftUI

@MainActor
struct SongsRootView: View {
    @State private var viewModel = SongViewModel()
    @State private var showingAddSong = false

    var body: some View {
        NavigationStack {
            // song List 출력
            List {
                ForEach(viewModel.songs) { song in
                    // 아이템을 선택하면 SongDetailView 출력
                    NavigationLink {
                        SongDetailView(song: song)
                    } label: {
                        SongRowView(song: song) 
                    }
                }
                // 삭제 (viewModel이 처리)
                .onDelete { offsets in
                    Task {
                        await viewModel.deleteSong(at: offsets)
                    }
                }
            }
            .navigationTitle("Songs")
            // toolbar(Song 추가 버튼)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSong = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            // AddSongView 출력
            .sheet(isPresented: $showingAddSong) {
                // AddSongView의 onSave 구현체 (입력 받은 데이터를 viewModel이 DB에 저장하는 구조)
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
