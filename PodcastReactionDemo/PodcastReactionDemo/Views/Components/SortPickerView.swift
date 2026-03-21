import SwiftUI

struct SortPickerView: View {
    @Binding var selection: CommentSortOption

    var body: some View {
        Picker("Sort", selection: $selection) {
            ForEach(CommentSortOption.allCases, id: \.self) { opt in
                Text(opt.title).tag(opt)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    SortPickerView(selection: .constant(.timeline))
        .padding()
}
