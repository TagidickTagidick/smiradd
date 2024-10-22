import SwiftUI

struct TeamEditAboutProjectView: View {
    @EnvironmentObject private var viewModel: TeamViewModel
    
    @FocusState var aboutProjectIsFocused: Bool
    
    var body: some View {
        CustomTextView(text: "О проекте")
        Spacer()
            .frame(
                height: 12
            )
        CustomTextFieldView(
            value: self.$viewModel.aboutProject,
            hintText: "Расскажите о проекте",
            focused: self.$aboutProjectIsFocused,
            height: 177,
            limit: 800,
            isLongText: true
        )
        .onTapGesture {
            self.aboutProjectIsFocused = true
        }
    }
}
