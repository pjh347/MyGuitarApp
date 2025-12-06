// Features/Practice/PracticeTabView.swift

import SwiftUI

struct PracticeRootView: View {
    @State private var songVM = SongViewModel()
    @State private var selectedSong: Song?

    var body: some View {
        NavigationStack {
            VStack {
                if songVM.songs.isEmpty {
                    ProgressView("곡 불러오는 중...")
                } else {
                    Picker("곡 선택", selection: $selectedSong) {
                        ForEach(songVM.songs) { song in
                            Text(song.title).tag(Optional(song))
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 120)

                    if let song = selectedSong {
                        ScoreListForPracticeView(song: song)
                            .id(song.id)
                    } else {
                        Text("연습할 곡을 선택하세요.")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("악보 연습")
            .task {
                await songVM.loadSongs()
                if selectedSong == nil {
                    selectedSong = songVM.songs.first
                }
            }
        }
    }
}
