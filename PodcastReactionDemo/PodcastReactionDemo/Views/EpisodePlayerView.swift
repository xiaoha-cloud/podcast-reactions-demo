import SwiftUI

@MainActor
struct EpisodePlayerView: View {
    @State private var viewModel: EpisodeViewModel
    @State private var isPlaying = false
    @State private var volume: Double = 0.65
    @State private var speedIndex = 1

    private let playbackSpeeds: [Double] = [0.75, 1.0, 1.25, 1.5, 2.0]

    init() {
        _viewModel = State(initialValue: EpisodeViewModel())
    }

    init(viewModel: EpisodeViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        @Bindable var vm = viewModel
        ZStack {
            EpisodePlayerBackground(coverImageName: vm.podcast.coverImageName)

            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        topMetadataRow(podcast: vm.podcast.title, episode: vm.episode.title)
                        queuePlaceholder
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer(minLength: 0)

                playbackStack(vm: vm)
                    .padding(.horizontal, 22)

                bottomAccessoryBar
                    .padding(.horizontal, 20)
                    .padding(.top, 2)
                    .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("Episode")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .tint(.white)
    }

    private func topMetadataRow(podcast: String, episode: String) -> some View {
        HStack(alignment: .center, spacing: 14) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.35), Color.white.opacity(0.12)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 72, height: 72)
                .overlay {
                    Image(systemName: "waveform")
                        .font(.title)
                        .foregroundStyle(.white.opacity(0.85))
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(episode)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                Text(podcast)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.65))
            }
            Spacer(minLength: 0)
            Image(systemName: "ellipsis.circle")
                .font(.title3)
                .foregroundStyle(.white.opacity(0.7))
                .accessibilityLabel("More")
        }
    }

    private var queuePlaceholder: some View {
        VStack(spacing: 10) {
            Text("Your Queue is Empty")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white.opacity(0.92))
            Text("Add episodes to listen in order.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }

    /// Progress through volume — pinned above the bottom icon bar, tight vertical rhythm.
    private func playbackStack(vm: EpisodeViewModel) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            SegmentedProgressTrack(
                currentSeconds: vm.currentPlaybackTime,
                durationSeconds: vm.episode.durationSeconds,
                onSeek: { vm.simulateSeek(to: $0) }
            )

            timeRow(current: vm.currentPlaybackTime, duration: vm.episode.durationSeconds)

            playbackControlsRow(vm: vm)

            volumeRow
        }
    }

    private func timeRow(current: Int, duration: Int) -> some View {
        let remaining = max(0, duration - current)
        return HStack {
            Text(TimeFormatter.mmss(from: current))
            Spacer()
            Text("-\(TimeFormatter.mmss(from: remaining))")
        }
        .font(.caption.monospacedDigit())
        .foregroundStyle(.white.opacity(0.75))
    }

    private func playbackControlsRow(vm: EpisodeViewModel) -> some View {
        let speed = playbackSpeeds[speedIndex]
        let speedText: String = {
            if speed == 1.0 { return "1x" }
            if speed == 2.0 { return "2x" }
            return String(format: "%.2fx", speed)
        }()
        return HStack(spacing: 0) {
            Button {
                speedIndex = (speedIndex + 1) % playbackSpeeds.count
            } label: {
                Text(speedText)
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                    .foregroundStyle(.white.opacity(0.9))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)

            Spacer(minLength: 8)

            Button {
                vm.simulateSeek(to: max(0, vm.currentPlaybackTime - 15))
            } label: {
                Image(systemName: "gobackward.15")
                    .font(.system(size: 34, weight: .regular))
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)

            Spacer(minLength: 8)

            Button {
                isPlaying.toggle()
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 52, weight: .regular))
                    .foregroundStyle(.white)
                    .frame(width: 72, height: 72)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isPlaying ? "Pause" : "Play")

            Spacer(minLength: 8)

            Button {
                vm.simulateSeek(to: min(vm.episode.durationSeconds, vm.currentPlaybackTime + 30))
            } label: {
                Image(systemName: "goforward.30")
                    .font(.system(size: 34, weight: .regular))
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)

            Spacer(minLength: 8)

            Button {
                // Sleep timer — demo placeholder
            } label: {
                Image(systemName: "moon.fill")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(.white.opacity(0.85))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Sleep timer")
        }
        .padding(.vertical, 2)
    }

    private var volumeRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "speaker.fill")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.55))
            Slider(value: $volume, in: 0 ... 1)
                .tint(.white.opacity(0.85))
            Image(systemName: "speaker.wave.3.fill")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.55))
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Volume")
    }

    /// Transcript · AirPlay · Comments — lighter chrome, closer to system player.
    private var bottomAccessoryBar: some View {
        HStack(spacing: 0) {
            Button {
                // Transcript placeholder
            } label: {
                Image(systemName: "text.alignleft")
                    .font(.system(size: 21, weight: .regular))
                    .foregroundStyle(.white.opacity(0.88))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Transcript")

            decorativeBottomIcon("airplayaudio")

            NavigationLink {
                CommentsView(viewModel: viewModel)
            } label: {
                Image(systemName: "bubble.left.and.bubble.right")
                    .font(.system(size: 21, weight: .regular))
                    .foregroundStyle(.white.opacity(0.88))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Comments")
        }
        .padding(.horizontal, 6)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Color.white.opacity(0.12), lineWidth: 0.5)
        )
    }

    private func decorativeBottomIcon(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 21, weight: .regular))
            .foregroundStyle(.white.opacity(0.35))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .accessibilityHidden(true)
            .allowsHitTesting(false)
    }
}

#Preview("Default") {
    NavigationStack {
        EpisodePlayerView()
    }
}

#Preview("Injected VM") {
    NavigationStack {
        EpisodePlayerView(viewModel: EpisodeViewModel.preview)
    }
}
