//  MiniGuitarTabView.swift
// MiniGuitarTabView.swift
import SwiftUI

struct MiniGuitarTabView: View {
    let notes: [Note]

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                // 6줄 기타 줄
                VStack(spacing: 6) {
                    ForEach((1...6).reversed(), id: \.self) { _ in
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(.gray.opacity(0.4))
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)

                // 음표 동그라미 (앞부분 몇 개만)
                let spacing = max(8, geo.size.width / CGFloat(max(notes.count, 1)))

                HStack(spacing: spacing) {
                    ForEach(notes) { note in
                        let (string, _) = stringAndFret(for: note)
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 5, height: 5)
                            .offset(y: miniYOffset(forString: string, height: geo.size.height))
                    }
                }
                .frame(height: geo.size.height)
            }
        }
    }

    // NoteListView와 동일한 튜닝 로직 재사용
    private func stringAndFret(for note: Note) -> (Int, Int) {
        if let s = note.stringNum, let f = note.fret {
            return (s, f)
        }
        let openMidis = [64, 59, 55, 50, 45, 40] // 1~6번줄
        for (i, open) in openMidis.enumerated() {
            let fret = note.pitchMidi - open
            if (0...20).contains(fret) {
                return (i + 1, fret)
            }
        }
        let fallbackFret = max(0, note.pitchMidi - 64)
        return (1, fallbackFret)
    }

    private func miniYOffset(forString string: Int, height: CGFloat) -> CGFloat {
        let lineCount = 6
        let spacing = height / CGFloat(lineCount + 1)
        // 6번줄이 위, 1번줄이 아래
        let idxFromTop = CGFloat(7 - string)
        return spacing * idxFromTop - height / 2
    }
}
