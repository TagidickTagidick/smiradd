import SwiftUI

struct CardEditJobTitleView: View {
    @EnvironmentObject private var viewModel: CardViewModel
    
    @FocusState var jobTitleIsFocused: Bool
    
    var body: some View {
        CustomTextView(
            text: "Должность/статус",
            isRequired: true
        )
        Spacer()
            .frame(height: 12)
        CustomTextFieldView(
            value: self.$viewModel.jobTitle,
            hintText: "Введите должность",
            focused: self.$jobTitleIsFocused,
            limit: 25,
            showCount: true
        )
        .onTapGesture {
            self.jobTitleIsFocused = true
        }
    }
}
