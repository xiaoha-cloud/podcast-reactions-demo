import SwiftUI

struct ReactionCommentRow: View {
    let comment: ReactionComment

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(comment.mood.displayEmoji)
                Text(comment.userName)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(TimeFormatter.mmss(from: comment.timestampSeconds))
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            Text(comment.content)
                .font(.subheadline)
            HStack {
                Text(comment.mood.displayName)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(comment.likesCount) likes")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
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
            )
        )
    }
}
