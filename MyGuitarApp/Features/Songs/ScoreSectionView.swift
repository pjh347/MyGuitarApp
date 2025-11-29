// ScoreSectionView.swift

import SwiftUI

struct ScoreSectionView: View {
    @State private var version: String = ""
    @State private var instrument: String = "guitar"

    let scores: [Score]
    let onAdd: (String?, String?) -> Void
    let onDelete: (IndexSet) -> Void

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
            ForEach(scores) { score in
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
            .onDelete(perform: onDelete)

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
