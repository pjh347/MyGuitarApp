// NoteListView.swift

import SwiftUI
import Foundation

enum NotePlayState {
    case pending
    case correct
    case wrong
}


struct NoteListView: View {
    @StateObject private var viewModel: NoteViewModel
    @State private var noteStates: [UUID: NotePlayState] = [:]
    @State private var currentIndex: Int = 0

    init(score: Score) {
        _viewModel = StateObject(wrappedValue: NoteViewModel(score: score))
    }
    
    /// 기타 6줄 배치용 Y offset 계산
    /// string: 1~6 (1번줄=가장 아래, 6번줄=가장 위)
    private func yOffset(forString string: Int) -> CGFloat {
        // string: 1~6 (1 = 가장 아래, 6 = 가장 위)
        let lineSpacing: CGFloat = 14   // 줄 간격
        let topOffset: CGFloat = -lineSpacing * 2.5  // 상단 기준 offset
        
        // string=6 → index=0, string=1 → index=5
        let indexFromTop = CGFloat(6 - string)
        
        return topOffset + indexFromTop * lineSpacing
    }


    var body: some View {
        VStack(spacing: 16) {
            Text("기타 탭 연습")
                .font(.headline)

            if viewModel.notes.isEmpty {
                Text("이 악보에는 아직 음표가 없습니다.")
                    .foregroundColor(.secondary)
            } else {
                tabView
                controlPanel
            }

            Spacer()
        }
        .padding()
        .navigationTitle("악보 연습")
        .task {
            await viewModel.loadNotes()
            currentIndex = 0
        }
    }

    // MARK: - TAB VIEW

    private var tabView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(viewModel.notes.enumerated()), id: \.1.id) { index, note in
                        let (string, fret) = stringAndFret(for: note)
                        NoteTabCell(
                            note: note,
                            index: index,
                            currentIndex: currentIndex,
                            state: noteStates[note.id] ?? .pending,
                            string: string,
                            fret: fret
                        )
                        .id(note.id)
                    }
                }
                .padding(.vertical, 8)
            }
            .frame(height: 120)
            .onChange(of: currentIndex) { idx in
                guard viewModel.notes.indices.contains(idx) else { return }
                let target = viewModel.notes[idx]
                withAnimation {
                    proxy.scrollTo(target.id, anchor: .leading)
                }
            }
        }
    }

    // MARK: - CONTROL PANEL (시뮬레이션용)

    private var controlPanel: some View {
        VStack(spacing: 8) {
            Text("현재 타겟: \(currentNoteLabel)")
                .font(.subheadline)

            HStack {
                Button {
                    moveToPrevious()
                } label: {
                    Label("이전", systemImage: "backward.fill")
                }
                .disabled(currentIndex == 0)

                Button {
                    simulateHit(correct: true)
                } label: {
                    Label("정답", systemImage: "checkmark.circle.fill")
                }

                Button {
                    simulateHit(correct: false)
                } label: {
                    Label("오답", systemImage: "xmark.octagon.fill")
                }

                Button {
                    moveToNext()
                } label: {
                    Label("다음", systemImage: "forward.fill")
                }
                .disabled(currentIndex >= max(0, viewModel.notes.count - 1))
            }
            .buttonStyle(.bordered)

            Text("※ 지금은 버튼으로 정답/오답을 시뮬레이션합니다.\n나중에 마이크 입력으로 대체할 예정입니다.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - HELPERS

    private var currentNoteLabel: String {
        guard viewModel.notes.indices.contains(currentIndex) else { return "-" }
        let n = viewModel.notes[currentIndex]
        return "#\(n.orderIndex), MIDI \(n.pitchMidi)"
    }

    private func color(for note: Note, index: Int) -> Color {
        let state = noteStates[note.id] ?? .pending
        switch state {
        case .pending:
            return currentIndex == index ? .blue : .black
        case .correct:
            return .blue
        case .wrong:
            return .red
        }
    }

    /// stringNum/fret가 있으면 그걸 쓰고, 없으면 pitchMidi로 추정
    private func stringAndFret(for note: Note) -> (Int, Int) {
        if let s = note.stringNum, let f = note.fret {
            return (s, f)
        }
        // 표준 튜닝: 1~6번줄
        let openMidis = [64, 59, 55, 50, 45, 40] // 1번~6번
        for (i, open) in openMidis.enumerated() {
            let fret = note.pitchMidi - open
            if (0...20).contains(fret) {
                return (i + 1, fret)
            }
        }
        // 범위 벗어나면 1번줄 기준으로 대충 매핑
        let fallbackFret = max(0, note.pitchMidi - 64)
        return (1, fallbackFret)
    }

    // MARK: - 시뮬레이션 / 진행 로직

    private func simulateHit(correct: Bool) {
        guard viewModel.notes.indices.contains(currentIndex) else { return }
        let note = viewModel.notes[currentIndex]
        noteStates[note.id] = correct ? .correct : .wrong

        // 맞추면 자동으로 다음 음으로 진행한다고 가정
        if correct {
            moveToNext()
        }
    }

    private func moveToNext() {
        guard !viewModel.notes.isEmpty else { return }
        currentIndex = min(currentIndex + 1, viewModel.notes.count - 1)
    }

    private func moveToPrevious() {
        guard !viewModel.notes.isEmpty else { return }
        currentIndex = max(currentIndex - 1, 0)
    }

    // 나중에 마이크 연결용
    /// 마이크에서 인식된 MIDI를 넘겨주면 여기서 정답/오답 판정
    func handleUserPlayed(midi: Int) {
        guard viewModel.notes.indices.contains(currentIndex) else { return }
        let target = viewModel.notes[currentIndex]
        let isCorrect = (target.pitchMidi == midi)
        simulateHit(correct: isCorrect)
    }
}

private struct NoteTabCell: View {
    let note: Note
    let index: Int
    let currentIndex: Int
    let state: NotePlayState
    let string: Int
    let fret: Int

    var body: some View {
        ZStack {
            // 6줄 줄 (각 카드마다 같은 위치에 그림)
            VStack(spacing: 8) {
                ForEach((1...6).reversed(), id: \.self) { lineString in
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.4))
                        .overlay(alignment: .leading) {
                            if lineString == string {
                                Circle()
                                    .fill(color)
                                    .frame(width: 18, height: 18)
                                    .overlay(
                                        Text("\(fret)")
                                            .font(.system(size: 9))
                                            .foregroundColor(.white)
                                    )
                                    .offset(x: 4)
                            }
                        }
                }
            }
        }
        .frame(width: 40, height: 80)
        .padding(.horizontal, 2)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .stroke(currentIndex == index ? Color.blue : .clear, lineWidth: 2)
        )
    }

    private var color: Color {
        switch state {
        case .pending:
            return currentIndex == index ? .blue : .black
        case .correct:
            return .blue
        case .wrong:
            return .red
        }
    }
}
