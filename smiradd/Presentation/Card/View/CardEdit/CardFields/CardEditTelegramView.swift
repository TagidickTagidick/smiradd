import SwiftUI

struct CardEditTelegramView: View {
    @EnvironmentObject private var viewModel: CardViewModel
    
    @FocusState var telegramIsFocused: Bool
    
    var body: some View {
        CustomTextView(text: "Telegram")
        Spacer()
            .frame(height: 12)
        CustomTextFieldView(
            value: self.$viewModel.telegram,
            hintText: "Введите ссылку",
            focused: self.$telegramIsFocused
        )
        .onTapGesture {
            self.telegramIsFocused = true
        }
        .onChange(of: self.viewModel.telegram) {
            self.viewModel.onChangeTelegram()
        }
    }
}
