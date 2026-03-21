import SwiftUI

@MainActor
struct MomentCommentsView: View {
    @Bindable var viewModel: EpisodeViewModel
    let timestampSeconds: Int

    private var momentComments: [ReactionComment] {
        viewModel.commentsForSelectedTimestamp()
    }

    var body: some View {
        Group {
            if momentComments.isEmpty {
                ContentUnavailableView(
                    "No comments for this moment yet",
                    systemImage: "bubble.left.and.bubble.right",
                    description: Text("Be the first to react at this timestamp.")
                )
            } else {
                List {
                    ForEach(momentComments) { c in
                        ReactionCommentRow(comment: c)
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
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(.bar)
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
