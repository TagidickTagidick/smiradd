import SwiftUI

struct CardEditSeekView: View {
    @EnvironmentObject private var viewModel: CardViewModel
    
    @FocusState var seekIsFocused: Bool
    
    var body: some View {
        CustomTextView(text: "Ищу")
        Spacer()
            .frame(height: 12)
        CustomTextFieldView(
            value: self.$viewModel.seek,
            hintText: "Кого или что вы ищете на форуме",
            focused: self.$seekIsFocused,
            height: 72,
            limit: 50,
            isLongText: true,
            showCount: true
        )
        .lineLimit(3)
        .onTapGesture {
            self.seekIsFocused = true
        }
    }
}
