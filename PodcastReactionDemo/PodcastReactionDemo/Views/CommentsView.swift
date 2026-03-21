import SwiftUI

@MainActor
struct CommentsView: View {
    @Bindable var viewModel: EpisodeViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                currentMomentEntry

                CommentTabBar(selection: $viewModel.selectedCommentTab)

                tabContent
            }
            .padding()
        }
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var currentMomentEntry: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Now playing")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            NavigationLink {
                MomentCommentsView(viewModel: viewModel, timestampSeconds: viewModel.currentPlaybackTime)
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("See comments at \(TimeFormatter.mmss(from: viewModel.currentPlaybackTime))")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)
                        if let first = viewModel.commentsForCurrentMoment().first {
                            Text(first.content)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        } else {
                            Text("No comments at this moment yet.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                }
                .padding()
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var tabContent: some View {
        switch viewModel.selectedCommentTab {
        case .all:
            commentList(viewModel.commentsForAllTab())
        case .latest:
            commentList(viewModel.commentsForLatestTab())
        case .moments:
            momentsList
        }
    }

    private func commentList(_ items: [ReactionComment]) -> some View {
        Group {
            if items.isEmpty {
                ContentUnavailableView(
                    "No comments yet",
                    systemImage: "bubble.left.and.bubble.right",
                    description: Text("Reactions will show up here.")
                )
                .frame(minHeight: 160)
            } else {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(items) { c in
                        ReactionCommentRow(comment: c)
                        Divider()
                    }
                }
            }
        }
    }

    private var momentsList: some View {
        let groups = viewModel.momentGroups()
        return Group {
            if groups.isEmpty {
                ContentUnavailableView(
                    "No moments yet",
                    systemImage: "clock",
                    description: Text("Comments grouped by timestamp will appear here.")
                )
                .frame(minHeight: 160)
            } else {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(groups) { group in
                        NavigationLink {
                            MomentCommentsView(viewModel: viewModel, timestampSeconds: group.timestampSeconds)
                        } label: {
                            MomentRowView(group: group)
                        }
                        Divider()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CommentsView(viewModel: EpisodeViewModel.preview)
    }
}
