import Foundation

enum CommentSortOption: String, CaseIterable, Codable, Sendable {
    case timeline
    case popular

    var title: String {
        switch self {
        case .timeline: "Timeline"
        case .popular: "Popular"
        }
    }
}
