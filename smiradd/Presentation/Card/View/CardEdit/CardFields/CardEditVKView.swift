import SwiftUI

struct CardEditVKView: View {
    @EnvironmentObject private var viewModel: CardViewModel
    
    @FocusState var vkIsFocused: Bool
    
    var body: some View {
        CustomTextView(text: "Вконтакте")
        Spacer()
            .frame(height: 12)
        CustomTextFieldView(
            value: self.$viewModel.vk,
            hintText: "Введите ссылку",
            focused: self.$vkIsFocused
        )
        .onTapGesture {
            self.vkIsFocused = true
        }
        .onChange(of: self.viewModel.vk) {
            self.viewModel.onChangeVk()
        }
    }
}
