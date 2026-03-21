import SwiftUI

@MainActor
struct MomentCommentsView: View {
    @Bindable var viewModel: EpisodeViewModel
    let timestampSeconds: Int

    /// Uses the navigation parameter (not only `selectedTimestampSeconds`) so the list matches the title before `.task` syncs the VM.
    private var momentComments: [ReactionComment] {
        viewModel.commentsForMoment(timestampSeconds: timestampSeconds)
    }

    var body: some View {
        Group {
            if momentComments.isEmpty {
                ContentUnavailableView(
                    "No comments for this moment yet",
                    systemImage: "bubble.left.and.bubble.right",
                    description: Text("Be the first to react at this timestamp.")
                )
                .frame(maxWidth: .infinity, minHeight: DesignTokens.EmptyState.minHeight)
                .padding(.horizontal, DesignTokens.Layout.commentStackHorizontal)
            } else {
                List {
                    ForEach(momentComments) { c in
                        ReactionCommentRow(comment: c, style: .momentDetail)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Comments at \(TimeFormatter.mmss(from: timestampSeconds))")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add comment") {
                    viewModel.openAddCommentSheet()
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            SortPickerView(selection: $viewModel.selectedSortOption)
                .padding(.horizontal, DesignTokens.Layout.commentStackHorizontal)
                .padding(.vertical, 8)
                .background(.bar)
        }
        .onAppear {
            viewModel.selectTimestamp(timestampSeconds)
        }
        .task(id: timestampSeconds) {
            viewModel.selectTimestamp(timestampSeconds)
        }
        .sheet(isPresented: $viewModel.isShowingAddCommentSheet) {
            AddCommentSheet(viewModel: viewModel)
        }
    }
}

#Preview {
    NavigationStack {
        MomentCommentsView(viewModel: EpisodeViewModel.preview, timestampSeconds: 754)
    }
}
