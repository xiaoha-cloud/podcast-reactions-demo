import Foundation

struct ReactionComment: Identifiable, Equatable, Hashable, Codable, Sendable {
    let id: UUID
    let episodeId: UUID
    let timestampSeconds: Int
    let userName: String
    let content: String
    let mood: ReactionMood
    let likesCount: Int
    let createdAt: Date
}
