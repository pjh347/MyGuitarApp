// MainTabView.swift

import SwiftUI

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
