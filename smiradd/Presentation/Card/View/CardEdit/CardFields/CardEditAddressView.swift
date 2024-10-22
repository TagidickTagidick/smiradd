import SwiftUI

struct CardEditAddressView: View {
    @EnvironmentObject private var viewModel: CardViewModel
    
    @FocusState var addressIsFocused: Bool
    
    var body: some View {
        CustomTextView(text: "Город")
        Spacer()
            .frame(height: 12)
        CustomTextFieldView(
            value: self.$viewModel.address,
            hintText: "Ваш город",
            focused: self.$addressIsFocused
        )
        .onTapGesture {
            self.addressIsFocused = true
        }
    }
}
