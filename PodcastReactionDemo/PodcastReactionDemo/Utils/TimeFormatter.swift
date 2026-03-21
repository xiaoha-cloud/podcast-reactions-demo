import Foundation
import SwiftUI

enum TimeFormatter {
    /// Formats whole seconds as `m:ss` / `mm:ss` (demo: no fractional seconds).
    static func mmss(from totalSeconds: Int) -> String {
        let s = max(0, totalSeconds)
        let m = s / 60
        let r = s % 60
        return String(format: "%d:%02d", m, r)
    }

    /// Short relative label for comment rows (e.g. “3 wk ago”).
    static func relativeShort(from date: Date, relativeTo now: Date = Date()) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: now)
    }
}

/// Layout and shape tokens for the **system-style comment stack** (Comments / Moment / Sheet).
/// Player chrome (`EpisodePlayerView`) keeps its own spacing for the pseudo–native shell.
enum DesignTokens {
    enum Layout {
        /// Horizontal padding for Comments scroll content, Moment empty states, and sheet-adjacent insets.
        static let commentStackHorizontal: CGFloat = 16
        static let commentStackVertical: CGFloat = 16
        static let sectionSpacing: CGFloat = 20
        static let rowDividerSpacing: CGFloat = 0
    }

    enum Card {
        static let cornerRadius: CGFloat = 12
        static let cornerStyle: RoundedCornerStyle = .continuous
    }

    enum EmptyState {
        static let minHeight: CGFloat = 200
    }

    enum CommentRow {
        static let verticalPadding: CGFloat = 10
        static let interLineSpacing: CGFloat = 4
    }
}
