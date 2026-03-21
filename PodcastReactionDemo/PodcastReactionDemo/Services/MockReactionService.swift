import Foundation

/// In-memory reactions store with sorting helpers. Views should use `EpisodeViewModel`, not this type directly from UI.
@MainActor
final class MockReactionService {
    private(set) var comments: [ReactionComment]
    let episode: Episode
    let podcast: Podcast

    init(podcast: Podcast, episode: Episode, initialComments: [ReactionComment]) {
        self.podcast = podcast
        self.episode = episode
        self.comments = initialComments
    }

    convenience init() {
        self.init(
            podcast: MockData.samplePodcast,
            episode: MockData.sampleEpisode,
            initialComments: MockData.sampleComments
        )
    }

    func allComments() -> [ReactionComment] {
        comments
    }

    func comments(atTimestampSeconds seconds: Int) -> [ReactionComment] {
        comments.filter { $0.timestampSeconds == seconds }
    }

    func addComment(timestampSeconds: Int, content: String, mood: ReactionMood, userName: String = "You") {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let new = ReactionComment(
            id: UUID(),
            episodeId: episode.id,
            timestampSeconds: timestampSeconds,
            userName: userName,
            content: trimmed,
            mood: mood,
            likesCount: 0,
            createdAt: Date()
        )
        comments.append(new)
    }

    /// Pure sort — does not mutate storage.
    func sortedComments(_ comments: [ReactionComment], by option: CommentSortOption) -> [ReactionComment] {
        switch option {
        case .timeline:
            return comments.sorted {
                if $0.createdAt != $1.createdAt {
                    return $0.createdAt > $1.createdAt
                }
                return $0.id.uuidString > $1.id.uuidString
            }
        case .popular:
            return comments.sorted {
                if $0.likesCount != $1.likesCount {
                    return $0.likesCount > $1.likesCount
                }
                if $0.createdAt != $1.createdAt {
                    return $0.createdAt > $1.createdAt
                }
                return $0.id.uuidString > $1.id.uuidString
            }
        }
    }
}
