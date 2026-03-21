import SwiftUI

struct CommentTabBar: View {
    @Binding var selection: CommentTab

    var body: some View {
        Picker("Tab", selection: $selection) {
            ForEach(CommentTab.allCases, id: \.self) { tab in
                Text(tab.title).tag(tab)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    CommentTabBar(selection: .constant(CommentTab.all))
        .padding()
}
