import SwiftUI

struct TeamEditAboutTeamView: View {
    @EnvironmentObject private var viewModel: TeamViewModel
    
    @FocusState var aboutTeamIsFocused: Bool
    
    var body: some View {
        CustomTextView(text: "О команде")
        Spacer()
            .frame(
                height: 12
            )
        CustomTextFieldView(
            value: self.$viewModel.aboutTeam,
            hintText: "Расскажите о себе",
            focused: self.$aboutTeamIsFocused,
            height: 177,
            limit: 800,
            isLongText: true
        )
        .onTapGesture {
            self.aboutTeamIsFocused = true
        }
    }
}
