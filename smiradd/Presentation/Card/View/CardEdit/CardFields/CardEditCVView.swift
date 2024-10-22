import SwiftUI

struct CardEditCVView: View {
    @EnvironmentObject private var viewModel: CardViewModel
    
    @FocusState var cvIsFocused: Bool
    
    var body: some View {
        CustomTextView(text: "Резюме")
        Spacer()
            .frame(height: 12)
        CustomTextFieldView(
            value: self.$viewModel.cv,
            hintText: "Вставьте ссылку",
            focused: self.$cvIsFocused
        )
        .onTapGesture {
            self.cvIsFocused = true
        }
    }
}
