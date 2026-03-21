import SwiftUI

struct MomentRowView: View {
    let group: MomentCommentGroup

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(TimeFormatter.mmss(from: group.timestampSeconds))
                    .font(.headline.weight(.semibold))
                    .monospacedDigit()
                Spacer(minLength: 0)
                Text("\(group.commentsCount) comments")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if group.totalLikesCount > 0 {
                Text("\(group.totalLikesCount) likes at this moment")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            ForEach(group.previewComments) { c in
                HStack(alignment: .top, spacing: 8) {
                    Text(c.mood.displayEmoji)
                        .font(.caption)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(c.userName)
                            .font(.caption.weight(.semibold))
                        Text(c.content)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    Spacer(minLength: 0)
                    Text("\(c.likesCount)")
                        .font(.caption2.monospacedDigit())
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .padding(.vertical, DesignTokens.CommentRow.verticalPadding)
    }
}

#Preview {
    List {
        MomentRowView(
            group: MomentCommentGroup(
                timestampSeconds: 754,
                commentsCount: 5,
                previewComments: [
                    ReactionComment(
                        id: UUID(),
                        episodeId: UUID(),
                        timestampSeconds: 754,
                        userName: "eli.nyc",
                        content: "Paused to breathe. That line stuck with me.",
                        mood: .thoughtful,
                        likesCount: 67,
                        createdAt: Date()
                    ),
                    ReactionComment(
                        id: UUID(),
                        episodeId: UUID(),
                        timestampSeconds: 754,
                        userName: "Rae☀️",
                        content: "LOL the example with the group chat is too real.",
                        mood: .funny,
                        likesCount: 8,
                        createdAt: Date()
                    )
                ],
                totalLikesCount: 120
            )
        )
    }
}
