import SwiftUI

struct CardEditNameView: View {
    @EnvironmentObject private var viewModel: CardViewModel
    
    @FocusState var nameIsFocused: Bool
    
    var body: some View {
        CustomTextView(
            text: "Имя Фамилия",
            isRequired: true
        )
        Spacer()
            .frame(height: 12)
        CustomTextFieldView(
            value: self.$viewModel.name,
            hintText: "Введите имя и фамилию",
            focused: self.$nameIsFocused,
            limit: 30,
            showCount: true
        )
        .onTapGesture {
            self.nameIsFocused = true
        }
    }
}
