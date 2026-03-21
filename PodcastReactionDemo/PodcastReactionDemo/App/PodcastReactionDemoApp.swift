import SwiftUI

@main
struct PodcastReactionDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                EpisodePlayerView()
            }
        }
    }
}
