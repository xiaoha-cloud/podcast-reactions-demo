import SwiftUI
import UIKit

@MainActor
struct AddCommentSheet: View {
    @Bindable var viewModel: EpisodeViewModel
    @State private var text = ""
    @State private var mood: ReactionMood = .funny

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if let ts = viewModel.selectedTimestampSeconds {
                        Text("Reacting to \(TimeFormatter.mmss(from: ts))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("No moment selected.")
                            .foregroundStyle(.secondary)
                    }
                }
                Section("Your reaction") {
                    TextField("What stood out?", text: $text, axis: .vertical)
                        .lineLimit(3 ... 8)
                    Picker("Mood", selection: $mood) {
                        ForEach(ReactionMood.allCases, id: \.self) { m in
                            Text("\(m.displayEmoji) \(m.displayName)").tag(m)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Add comment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.closeAddCommentSheet()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        viewModel.addComment(content: text, mood: mood)
                        text = ""
                        viewModel.closeAddCommentSheet()
                    }
                    .disabled(viewModel.selectedTimestampSeconds == nil || text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddCommentSheet(viewModel: EpisodeViewModel.preview)
}
