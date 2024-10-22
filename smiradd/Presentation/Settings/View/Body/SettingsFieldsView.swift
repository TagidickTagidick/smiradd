import SwiftUI

struct SettingsFieldsView: View {
    @EnvironmentObject private var viewModel: SettingsViewModel
    
    var firstNameIsFocused: FocusState<Bool>.Binding
    var lastNameIsFocused: FocusState<Bool>.Binding
    
    var body: some View {
        CustomTextView(text: "Имя*")
        Spacer()
            .frame(height: 8)
        CustomTextFieldView(
            value: self.$viewModel.firstName,
            hintText: "Введите имя",
            focused: self.firstNameIsFocused
        )
        Spacer()
            .frame(height: 16)
        CustomTextView(text: "Фамилия*")
        Spacer()
            .frame(height: 8)
        CustomTextFieldView(
            value: self.$viewModel.lastName,
            hintText: "Введите фамилию",
            focused: self.lastNameIsFocused
        )
    }
}
