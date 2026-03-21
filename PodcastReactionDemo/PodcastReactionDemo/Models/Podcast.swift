import Foundation

struct Podcast: Identifiable, Equatable, Hashable, Codable, Sendable {
    let id: UUID
    let title: String
    let author: String
    let coverImageName: String
}
