import Foundation
import Observation

@MainActor
@Observable
final class EpisodeViewModel {
    private let service: MockReactionService

    /// Bumps when service-backed comments change so Observation refreshes UI.
    private(set) var commentRevision: Int = 0

    var episode: Episode { service.episode }
    var podcast: Podcast { service.podcast }

    var currentPlaybackTime: Int = 0
    /// Focused moment for `MomentCommentsView` / add-comment flow.
    var selectedTimestampSeconds: Int?

    /// Timeline vs Popular — **only** for `MomentCommentsView` / `commentsForSelectedTimestamp()`.
    var selectedSortOption: CommentSortOption = .timeline

    var selectedCommentTab: CommentTab = .all

    var isShowingAddCommentSheet = false

    /// Distinct reaction anchor seconds (from live comments).
    var highlightTimestampsSeconds: [Int] {
        _ = commentRevision
        return Set(service.allComments().map(\.timestampSeconds)).sorted()
    }

    /// Full episode comment list snapshot (unsorted).
    var allComments: [ReactionComment] {
        _ = commentRevision
        return service.allComments()
    }

    init(service: MockReactionService) {
        self.service = service
    }

    convenience init() {
        self.init(service: MockReactionService())
    }

    func sortedComments(_ comments: [ReactionComment], by option: CommentSortOption) -> [ReactionComment] {
        service.sortedComments(comments, by: option)
    }

    /// Optional hook before pushing `CommentsView` (navigation is primary path).
    func openComments() {}

    func selectCommentTab(_ tab: CommentTab) {
        selectedCommentTab = tab
    }

    /// Sets focused moment and syncs simulated playback (demo UX).
    func selectTimestamp(_ seconds: Int) {
        selectedTimestampSeconds = seconds
        simulateSeek(to: seconds)
    }

    /// **All**: follow the episode — anchor time ascending, then newest comment first within the same second.
    func commentsForAllTab() -> [ReactionComment] {
        _ = commentRevision
        return service.allComments().sorted {
            if $0.timestampSeconds != $1.timestampSeconds {
                return $0.timestampSeconds < $1.timestampSeconds
            }
            if $0.createdAt != $1.createdAt {
                return $0.createdAt > $1.createdAt
            }
            return $0.id.uuidString > $1.id.uuidString
        }
    }

    /// **Latest**: global “newest activity first” — `createdAt` descending (independent of anchor order).
    func commentsForLatestTab() -> [ReactionComment] {
        _ = commentRevision
        return service.sortedComments(service.allComments(), by: .timeline)
    }

    /// **Moments**: group by `timestampSeconds`; preview = top 2 by `likesCount` (per doc example).
    func momentGroups() -> [MomentCommentGroup] {
        _ = commentRevision
        let grouped = Dictionary(grouping: service.allComments(), by: \.timestampSeconds)
        return grouped.keys.sorted().map { ts in
            let comments = grouped[ts]!
            let preview = comments
                .sorted {
                    if $0.likesCount != $1.likesCount {
                        return $0.likesCount > $1.likesCount
                    }
                    if $0.createdAt != $1.createdAt {
                        return $0.createdAt > $1.createdAt
                    }
                    return $0.id.uuidString > $1.id.uuidString
                }
                .prefix(2)
            let totalLikes = comments.reduce(0) { $0 + $1.likesCount }
            return MomentCommentGroup(
                timestampSeconds: ts,
                commentsCount: comments.count,
                previewComments: Array(preview),
                totalLikesCount: totalLikes
            )
        }
    }

    /// Comments at the **current playhead** — always timeline order (no Popular here).
    func commentsForCurrentMoment() -> [ReactionComment] {
        _ = commentRevision
        let t = currentPlaybackTime
        let at = service.comments(atTimestampSeconds: t)
        return service.sortedComments(at, by: .timeline)
    }

    /// Selected moment detail — respects `selectedSortOption` (Moment page only).
    func commentsForSelectedTimestamp() -> [ReactionComment] {
        _ = commentRevision
        guard let seconds = selectedTimestampSeconds else { return [] }
        let atPoint = service.comments(atTimestampSeconds: seconds)
        return service.sortedComments(atPoint, by: selectedSortOption)
    }

    func addComment(content: String, mood: ReactionMood) {
        guard let ts = selectedTimestampSeconds else { return }
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        service.addComment(timestampSeconds: ts, content: trimmed, mood: mood)
        commentRevision += 1
    }

    func simulateSeek(to seconds: Int) {
        let clamped = min(max(0, seconds), episode.durationSeconds)
        currentPlaybackTime = clamped
    }

    func openAddCommentSheet() {
        isShowingAddCommentSheet = true
    }

    func closeAddCommentSheet() {
        isShowingAddCommentSheet = false
    }
}

extension EpisodeViewModel {
    static let preview: EpisodeViewModel = {
        let vm = EpisodeViewModel()
        vm.selectTimestamp(vm.highlightTimestampsSeconds.first ?? 195)
        return vm
    }()
}
