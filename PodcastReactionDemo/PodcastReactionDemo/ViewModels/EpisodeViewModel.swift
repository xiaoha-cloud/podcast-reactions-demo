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
    /// Focused moment for `MomentCommentsView` / add-comment flow. Not cleared when the add sheet dismisses.
    var selectedTimestampSeconds: Int?

    /// Timeline vs Popular — **only** for `MomentCommentsView` / `commentsForMoment` / `commentsForSelectedTimestamp()`.
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
        #if DEBUG
        simulateSeek(to: MockData.demoInterviewPlayheadSeconds)
        #endif
    }

    convenience init() {
        self.init(service: MockReactionService())
    }

    /// Delegates to `MockReactionService` sort helpers (Latest tab uses `.timeline` = newest `createdAt` first).
    func sortedComments(_ comments: [ReactionComment], by option: CommentSortOption) -> [ReactionComment] {
        service.sortedComments(comments, by: option)
    }

    /// Optional hook when `CommentsView` appears (navigation remains the primary entry).
    func openComments() {}

    /// Switches the All / Latest / Moments hub tab.
    func selectCommentTab(_ tab: CommentTab) {
        selectedCommentTab = tab
    }

    /// Sets the focused moment, updates `selectedTimestampSeconds`, and moves the **simulated** playhead for demo UX.
    func selectTimestamp(_ seconds: Int) {
        selectedTimestampSeconds = seconds
        simulateSeek(to: seconds)
    }

    /// **All tab**: episode order — anchor time ascending; within the same second, newest `createdAt` first.
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

    /// **Latest tab**: global activity — `createdAt` descending (same as service “timeline” sort on the full list).
    func commentsForLatestTab() -> [ReactionComment] {
        _ = commentRevision
        return service.sortedComments(service.allComments(), by: .timeline)
    }

    /// **Moments tab**: one row per anchor second; preview picks top comments by likes for the row body.
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

    /// Comments at the **current playhead** only — timeline order; no Popular sort on this surface.
    func commentsForCurrentMoment() -> [ReactionComment] {
        _ = commentRevision
        let t = currentPlaybackTime
        let at = service.comments(atTimestampSeconds: t)
        return service.sortedComments(at, by: .timeline)
    }

    /// One anchor second, sorted by `selectedSortOption` — list data for `MomentCommentsView` (uses the pushed `timestampSeconds`).
    func commentsForMoment(timestampSeconds: Int) -> [ReactionComment] {
        _ = commentRevision
        let atPoint = service.comments(atTimestampSeconds: timestampSeconds)
        return service.sortedComments(atPoint, by: selectedSortOption)
    }

    /// Same as `commentsForMoment` but uses `selectedTimestampSeconds` (nil → empty); observation-friendly when selection is empty.
    func commentsForSelectedTimestamp() -> [ReactionComment] {
        guard let seconds = selectedTimestampSeconds else {
            _ = commentRevision
            return []
        }
        return commentsForMoment(timestampSeconds: seconds)
    }

    /// Appends a comment at `selectedTimestampSeconds` (must match the moment on screen). Bumps `commentRevision`.
    func addComment(content: String, mood: ReactionMood) {
        guard let ts = selectedTimestampSeconds else { return }
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        service.addComment(timestampSeconds: ts, content: trimmed, mood: mood)
        commentRevision += 1
    }

    /// Demo-only simulated seek — clamps to episode duration and updates `currentPlaybackTime`.
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
        vm.selectTimestamp(MockData.demoInterviewPlayheadSeconds)
        return vm
    }()
}
