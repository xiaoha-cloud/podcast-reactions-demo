import SwiftUI

struct MockPlayerCardView: View {
    let podcastTitle: String
    let episodeTitle: String
    let coverImageName: String
    let currentSeconds: Int
    let durationSeconds: Int
    let onSeek: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                coverArt
                VStack(alignment: .leading, spacing: 4) {
                    Text(podcastTitle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text(episodeTitle)
                        .font(.headline)
                        .lineLimit(3)
                }
                Spacer(minLength: 0)
            }

            VStack(spacing: 8) {
                Slider(
                    value: Binding(
                        get: { Double(currentSeconds) },
                        set: { onSeek(Int($0.rounded())) }
                    ),
                    in: 0 ... Double(max(durationSeconds, 1))
                )
                .tint(.accentColor)

                HStack {
                    Text(TimeFormatter.mmss(from: currentSeconds))
                    Spacer()
                    Text(TimeFormatter.mmss(from: durationSeconds))
                }
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)

                HStack(spacing: 24) {
                    Button {
                        onSeek(max(0, currentSeconds - 15))
                    } label: {
                        Image(systemName: "gobackward.15")
                            .font(.title2)
                    }
                    Button {
                        onSeek(min(durationSeconds, currentSeconds + 15))
                    } label: {
                        Image(systemName: "goforward.15")
                            .font(.title2)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private var coverArt: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(
                LinearGradient(
                    colors: [Color.accentColor.opacity(0.35), Color.accentColor.opacity(0.15)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 88, height: 88)
            .overlay {
                Image(systemName: "waveform")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            }
            .accessibilityLabel("Cover \(coverImageName)")
    }
}

#Preview {
    MockPlayerCardView(
        podcastTitle: "Deep Listen",
        episodeTitle: "How Technology Shapes Attention",
        coverImageName: "CoverDeepListen",
        currentSeconds: 120,
        durationSeconds: 2300,
        onSeek: { _ in }
    )
    .padding()
}
