import Foundation

enum ReactionMood: String, CaseIterable, Codable, Sendable {
    case funny
    case thoughtful
    case surprising
    case meaningful

    var displayEmoji: String {
        switch self {
        case .funny: "😂"
        case .thoughtful: "🤔"
        case .surprising: "😮"
        case .meaningful: "❤️"
        }
    }

    var displayName: String {
        switch self {
        case .funny: "Funny"
        case .thoughtful: "Thoughtful"
        case .surprising: "Surprising"
        case .meaningful: "Meaningful"
        }
    }
}
