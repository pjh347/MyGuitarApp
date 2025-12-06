import SwiftUI

struct PracticeTuningView: View {
    let noteName: String        // 예: "E2"
    let targetMidi: Int         // 예: 40
    let targetFreq: Double      // 예: 82.41Hz

    @State private var currentFreq: Double = 70.0

    // offset = 현재음 - 목표음 (Hz 기반)
    private var offset: Double {
        currentFreq - targetFreq
    }

    private var statusText: String {
        switch offset {
        case ..<(-3): return "너무 낮음"
        case -3..<(-1): return "조금 낮음"
        case -1...1: return "정확합니다! 🎉"
        case 1..<3: return "조금 높음"
        default: return "너무 높음"
        }
    }

    private var statusColor: Color {
        switch offset {
        case -1...1: return .green
        case -3..<(-1), 1..<3: return .orange
        default: return .red
        }
    }

    var body: some View {
        VStack(spacing: 24) {

            Text("연습 중인 음")
                .font(.headline)

            Text(noteName)
                .font(.system(size: 56, weight: .bold))

            Text(String(format: "목표: %.2f Hz", targetFreq))
                .font(.title2)
                .foregroundColor(.secondary)

            Divider().padding(.vertical, 12)

            // ---- 현재 Hz 표시 ----
            VStack {
                Text("현재 음")
                    .font(.headline)
                Text(String(format: "%.2f Hz", currentFreq))
                    .font(.system(size: 36, weight: .semibold))
            }

            // ---- 오프셋 상태 ----
            Text(statusText)
                .font(.title2.bold())
                .foregroundColor(statusColor)
                .padding(.top, 8)

            // ---- 테스트용 슬라이더 ----
            VStack(spacing: 8) {
                Text("현재 음 시뮬레이션 (나중에 마이크 입력으로 대체)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Slider(value: $currentFreq,
                       in: (targetFreq-20)...(targetFreq+20))
            }

            Spacer()
        }
        .padding()
        .navigationTitle("튜닝 연습")
    }
}
