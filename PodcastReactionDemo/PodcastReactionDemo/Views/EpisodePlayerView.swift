import SwiftUI

struct EpisodePlayerView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Podcast Reaction Demo")
                    .font(.title2.weight(.semibold))
                Text("Episode")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Episode")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    EpisodePlayerView()
}
