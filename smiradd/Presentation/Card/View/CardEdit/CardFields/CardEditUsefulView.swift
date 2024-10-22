import SwiftUI

struct CardEditUsefulView: View {
    @EnvironmentObject private var viewModel: CardViewModel
    
    @FocusState var usefulIsFocused: Bool
    
    var body: some View {
        CustomTextView(text: "Полезен")
        Spacer()
            .frame(height: 12)
        CustomTextFieldView(
            value: self.$viewModel.useful,
            hintText: "Чем вы могли бы быть полезны другим усастникам",
            focused: self.$usefulIsFocused,
            height: 72,
            limit: 50,
            isLongText: true,
            showCount: true
        )
        .lineLimit(3)
        .onTapGesture {
            self.usefulIsFocused = true
        }
    }
}
