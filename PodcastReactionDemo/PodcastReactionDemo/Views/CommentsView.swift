import SwiftUI
import UIKit

@MainActor
struct CommentsView: View {
    @Bindable var viewModel: EpisodeViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.Layout.sectionSpacing) {
                currentMomentEntry

                CommentTabBar(selection: $viewModel.selectedCommentTab)

                tabContent
            }
            .padding(.horizontal, DesignTokens.Layout.commentStackHorizontal)
            .padding(.vertical, DesignTokens.Layout.commentStackVertical)
        }
        .background(Color(uiColor: .systemBackground))
        .onAppear {
            viewModel.openComments()
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
                            Text("Be the first to react at this timestamp.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                }
                .padding(DesignTokens.Layout.commentStackVertical)
                .background(
                    Color(.secondarySystemBackground),
                    in: RoundedRectangle(cornerRadius: DesignTokens.Card.cornerRadius, style: DesignTokens.Card.cornerStyle)
                )
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
                emptyAllOrLatest
            } else {
                LazyVStack(alignment: .leading, spacing: DesignTokens.Layout.rowDividerSpacing) {
                    ForEach(items) { c in
                        ReactionCommentRow(comment: c, style: .globalList)
                        Divider()
                    }
                }
            }
        }
    }

    private var emptyAllOrLatest: some View {
        ContentUnavailableView(
            "No comments yet",
            systemImage: "bubble.left.and.bubble.right",
            description: Text("Reactions will show up here.")
        )
        .frame(minHeight: DesignTokens.EmptyState.minHeight)
    }

    private var momentsList: some View {
        let groups = viewModel.momentGroups()
        return Group {
            if groups.isEmpty {
                ContentUnavailableView(
                    "No highlighted moments yet",
                    systemImage: "clock",
                    description: Text("Comments grouped by time will appear here.")
                )
                .frame(minHeight: DesignTokens.EmptyState.minHeight)
            } else {
                LazyVStack(alignment: .leading, spacing: DesignTokens.Layout.rowDividerSpacing) {
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
