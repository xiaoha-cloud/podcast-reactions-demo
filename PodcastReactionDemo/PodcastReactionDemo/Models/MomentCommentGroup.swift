import Foundation

/// One anchor second in the episode, aggregated for the Moments tab.
struct MomentCommentGroup: Identifiable, Equatable, Hashable, Sendable {
    var id: Int { timestampSeconds }
    let timestampSeconds: Int
    let commentsCount: Int
    /// Top comments by likes (document example: up to 2 for row preview).
    let previewComments: [ReactionComment]
    /// Sum of likes at this timestamp (optional enrichment for UI / debugging).
    let totalLikesCount: Int
}
