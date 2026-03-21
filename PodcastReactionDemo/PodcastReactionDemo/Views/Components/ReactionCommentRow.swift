import SwiftUI

struct ReactionCommentRow: View {
    enum Style {
        /// All / Latest: show anchor `mm:ss` on the meta row (context-driven).
        case globalList
        /// Single-moment screen: title already shows time; meta row omits duplicate anchor.
        case momentDetail
    }

    let comment: ReactionComment
    var style: Style = .globalList

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.CommentRow.interLineSpacing) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(comment.userName)
                    .font(.subheadline.weight(.semibold))
                Text("\(comment.mood.displayEmoji) \(comment.mood.displayName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer(minLength: 0)
                Text("\(comment.likesCount)")
                    .font(.caption2.monospacedDigit())
                    .foregroundStyle(.tertiary)
                Text("likes")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Text(comment.content)
                .font(.body)
                .foregroundStyle(.primary)
                .lineLimit(5)
                .fixedSize(horizontal: false, vertical: true)

            metaRow
        }
        .padding(.vertical, DesignTokens.CommentRow.verticalPadding)
    }

    @ViewBuilder
    private var metaRow: some View {
        switch style {
        case .globalList:
            HStack(spacing: 4) {
                Text(TimeFormatter.relativeShort(from: comment.createdAt))
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                Text("·")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                Text(TimeFormatter.mmss(from: comment.timestampSeconds))
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.tertiary)
            }
        case .momentDetail:
            Text(TimeFormatter.relativeShort(from: comment.createdAt))
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }
}

#Preview("Global list") {
    List {
        ReactionCommentRow(
            comment: ReactionComment(
                id: UUID(),
                episodeId: UUID(),
                timestampSeconds: 754,
                userName: "eli.nyc",
                content: "Paused to breathe. That line about borrowed attention stuck with me.",
                mood: .thoughtful,
                likesCount: 12,
                createdAt: Date()
            ),
            style: .globalList
        )
    }
}

#Preview("Moment detail") {
    List {
        ReactionCommentRow(
            comment: ReactionComment(
                id: UUID(),
                episodeId: UUID(),
                timestampSeconds: 754,
                userName: "eli.nyc",
                content: "Paused to breathe.",
                mood: .thoughtful,
                likesCount: 12,
                createdAt: Date()
            ),
            style: .momentDetail
        )
    }
}
