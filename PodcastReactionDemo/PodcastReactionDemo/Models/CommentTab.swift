import Foundation

enum CommentTab: String, CaseIterable, Codable, Sendable {
    case all
    case latest
    case moments

    var title: String {
        switch self {
        case .all: "All"
        case .latest: "Latest"
        case .moments: "Moments"
        }
    }
}
