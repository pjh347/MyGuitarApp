// Features/Scores/ScoreSectionView.swift
// SongDetailView에 사용될 악보 section view

import SwiftUI

struct ScoreSectionView: View {
    // 버전(기본, 쉬운버전 ...등), 악기를 입력으로 받음
    @State private var version: String = ""
    @State private var instrument: String = "guitar"

    // 악보 리스트
    let scores: [Score]
    // 부모(SongDetailView)로 부터 받은 악보 저장 콜백 함수
    let onAdd: (String?, String?) -> Void
    // 부모(SongDetailView)로 부터 받은 악보 삭제 콜백 함수
    let onDelete: (IndexSet) -> Void

    // 기타, 피아노, 바이올린을 이모지로 출력 (DB에는 String으로 저장, View에서 이모지로 출력)
    private func emoji(for instrument: String?) -> String {
        switch instrument {
        case "guitar": return "🎸"
        case "piano":  return "🎹"
        case "violin": return "🎻"
        default:       return "🎵"
        }
    }

    var body: some View {
        Section("악보") {
            // MARK: -SCORE_LIST_VIEW
            ForEach(scores) { score in
                NavigationLink {
                    NoteListView(score: score)
                } label: {
                    HStack {
                        Text(emoji(for: score.instrument))
                        VStack(alignment: .leading) {
                            Text(score.version ?? "기본 버전")
                            if let inst = score.instrument {
                                Text(inst)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .onDelete(perform: onDelete)

            // MARK: -SCORE_ADD_VIEW
            VStack(alignment: .leading) {
                Text("새 악보 추가")
                    .font(.subheadline)

                TextField("버전 이름 (예: 기본, 쉬운 버전)", text: $version)

                Picker("악기", selection: $instrument) {
                    Text("기타 🎸").tag("guitar")
                    Text("피아노 🎹").tag("piano")
                    Text("바이올린 🎻").tag("violin")
                }
                .pickerStyle(.segmented)

                Button {
                    onAdd(
                        version.trimmingCharacters(in: .whitespaces).isEmpty ? nil : version,
                        instrument
                    )
                    version = ""
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("악보 추가")
                    }
                }
                .disabled(version.trimmingCharacters(in: .whitespaces).isEmpty)
                .padding(.top, 4)
            }
        }
    }
}
