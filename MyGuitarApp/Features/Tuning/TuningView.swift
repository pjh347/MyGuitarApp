import SwiftUI

struct TuningView: View {

    // 6줄 기타 표준 튜닝 정보
    private struct GuitarStringInfo: Identifiable {
        let id = UUID()
        let name: String       // "6번줄 (저음 E)" 등
        let noteName: String   // "E2"
        let frequency: Double  // 82.41
    }

    private let strings: [GuitarStringInfo] = [
        .init(name: "6번줄 (저음 E)", noteName: "E2", frequency: 82.41),
        .init(name: "5번줄 (A)",      noteName: "A2", frequency: 110.00),
        .init(name: "4번줄 (D)",      noteName: "D3", frequency: 146.83),
        .init(name: "3번줄 (G)",      noteName: "G3", frequency: 196.00),
        .init(name: "2번줄 (B)",      noteName: "B3", frequency: 246.94),
        .init(name: "1번줄 (고음 E)", noteName: "E4", frequency: 329.63)
    ]

    // 현재 선택된 줄 index
    @State private var selectedIndex: Int = 0

    /// 현재 음이 타겟에서 얼마나 벗어났는지
    /// -50: 많이 낮음, 0: 정확, +50: 많이 높음
    @State private var pitchOffset: Double = 0

    // 상태 텍스트
    private var statusText: String {
        switch pitchOffset {
        case ..<(-20): return "너무 낮음"
        case -20..<(-5): return "조금 낮음"
        case -5...5: return "거의 맞음 👍"
        case 5..<20: return "조금 높음"
        default: return "너무 높음"
        }
    }

    // 상태 색깔
    private var statusColor: Color {
        switch pitchOffset {
        case -5...5: return .green
        case -20..<(-5), 5..<20: return .orange
        default: return .red
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // MARK: - 줄 선택
                VStack(alignment: .leading, spacing: 8) {
                    Text("튜닝할 줄 선택")
                        .font(.headline)

                    Picker("기타 줄", selection: $selectedIndex) {
                        ForEach(strings.indices, id: \.self) { index in
                            Text(strings[index].name).tag(index)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 120)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Divider()

                // MARK: - 타겟 음 정보
                let current = strings[selectedIndex]

                VStack(spacing: 4) {
                    Text("목표 음")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("\(current.noteName)")
                        .font(.largeTitle)
                        .bold()

                    Text(String(format: "%.2f Hz", current.frequency))
                        .font(.title3)
                        .foregroundColor(.secondary)
                }

                // MARK: - 현재 음 높낮이 (시뮬레이션)
                VStack(spacing: 12) {
                    Text("현재 음 높낮이 (시뮬레이션)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Slider(value: $pitchOffset, in: -50...50, step: 1)

                    Text(statusText)
                        .font(.title2)
                        .bold()
                        .foregroundColor(statusColor)
                        .padding(.top, 4)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Tuning")
        }
    }
}

#Preview {
    TuningView()
}
