// MainTabView.swift

import SwiftUI

// 3개의 TabView: Songs(노래 리스트), Favorites(즐겨찾기 리스트), Settings(설정 화면)
struct MainTabView: View {
    var body: some View {
        TabView {
            SongsRootView()
                .tabItem {
                    Label("Songs", systemImage: "music.note.list")
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}
