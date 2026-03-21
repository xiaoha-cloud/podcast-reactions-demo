import SwiftUI

/// Segmented progress bar similar to Apple Podcasts’ “chapter” style scrubber (visual only; tap-to-seek can extend later).
struct SegmentedProgressTrack: View {
    let currentSeconds: Int
    let durationSeconds: Int
    let onSeek: (Int) -> Void

    private let segmentCount = 8

    var body: some View {
        GeometryReader { geo in
            let totalW = geo.size.width
            let gap: CGFloat = 3
            let segW = (totalW - gap * CGFloat(segmentCount - 1)) / CGFloat(segmentCount)
            let progress = durationSeconds > 0 ? Double(currentSeconds) / Double(durationSeconds) : 0
            let filledThrough = progress * Double(segmentCount)

            HStack(spacing: gap) {
                ForEach(0 ..< segmentCount, id: \.self) { i in
                    let fillAmount = min(max(filledThrough - Double(i), 0), 1)
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.22))
                        Capsule()
                            .fill(Color.white.opacity(0.92))
                            .frame(width: max(0, CGFloat(fillAmount) * segW))
                    }
                    .frame(width: segW, height: 5)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let target = Double(i) / Double(segmentCount)
                        let seconds = Int((target * Double(max(durationSeconds, 1))).rounded())
                        onSeek(seconds)
                    }
                }
            }
        }
        .frame(height: 6)
    }
}

#Preview {
    SegmentedProgressTrack(currentSeconds: 120, durationSeconds: 2300, onSeek: { _ in })
        .padding()
        .background(Color.black)
}
