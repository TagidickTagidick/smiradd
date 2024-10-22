import SwiftUI

struct CardEditEmailView: View {
    @EnvironmentObject private var viewModel: CardViewModel
    
    @FocusState var emailIsFocused: Bool
    
    var body: some View {
        CustomTextView(
            text: "Почта",
            isRequired: true
        )
        Spacer()
            .frame(height: 12)
        CustomTextFieldView(
            value: self.$viewModel.email,
            hintText: "example@mail.com",
            focused: self.$emailIsFocused
        )
        .onChange(of: self.emailIsFocused) {
            self.viewModel.checkEmail()
        }
        .onTapGesture {
            self.emailIsFocused = true
        }
        if !self.viewModel.isValidEmail {
            Spacer()
                .frame(
                    height: 12
                )
            Text("Адрес электронной почты не валиден")
            .font(
                .custom(
                    "OpenSans-Regular",
                    size: 14
                )
            )
            .foregroundStyle(
                Color(
                    red: 0.898,
                    green: 0.271,
                    blue: 0.267
                )
            )
        }
    }
}
