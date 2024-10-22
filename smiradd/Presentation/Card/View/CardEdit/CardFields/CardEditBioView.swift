import SwiftUI

struct CardEditBioView: View {
    @EnvironmentObject private var viewModel: CardViewModel
    
    @FocusState var bioIsFocused: Bool
    
    var body: some View {
        CustomTextView(
            text: "О себе"
        )
        Spacer()
            .frame(height: 12)
        CustomTextFieldView(
            value: self.$viewModel.bio,
            hintText: "Расскажите о себе",
            focused: self.$bioIsFocused,
            height: 177,
            limit: 500,
            isLongText: true,
            showCount: true
        )
        .lineLimit(8)
        .onTapGesture {
            self.bioIsFocused = true
        }
    }
}
