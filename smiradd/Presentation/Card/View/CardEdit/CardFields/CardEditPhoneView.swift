import SwiftUI

struct CardEditPhoneView: View {
    @EnvironmentObject private var viewModel: CardViewModel
    
    @FocusState var phoneIsFocused: Bool
    
    var body: some View {
        CustomTextView(
            text: "Номер телефона",
            isRequired: true
        )
        Spacer()
            .frame(height: 12)
        CustomTextFieldView(
            value: self.$viewModel.phone,
            hintText: "X (XXX) XXX-XX-XX",
            focused: self.$phoneIsFocused,
            limit: 17
        )
        .keyboardType(.numberPad)
        .onTapGesture {
            self.phoneIsFocused = true
        }
        .onChange(of: self.viewModel.phone) {
            self.viewModel.onChangePhone()
            
            if (self.viewModel.phone.count == 17) {
                self.phoneIsFocused = false
            }
        }
    }
}
