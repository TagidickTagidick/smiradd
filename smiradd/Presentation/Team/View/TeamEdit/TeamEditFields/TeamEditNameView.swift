import SwiftUI

struct TeamEditNameView: View {
    @EnvironmentObject private var viewModel: TeamViewModel
    
    @FocusState var nameIsFocused: Bool
    
    var body: some View {
        CustomTextView(
            text: "Название команды",
            isRequired: true
        )
        Spacer()
            .frame(
                height: 12
            )
        CustomTextFieldView(
            value: self.$viewModel.name,
            hintText: "Введите должность",
            focused: self.$nameIsFocused
        )
        .onTapGesture {
            self.nameIsFocused = true
        }
    }
}
