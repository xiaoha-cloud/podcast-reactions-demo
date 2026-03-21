import Foundation

struct Episode: Identifiable, Equatable, Hashable, Codable, Sendable {
    let id: UUID
    let podcastId: UUID
    let title: String
    let description: String
    let durationSeconds: Int
}
