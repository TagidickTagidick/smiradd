import SwiftUI

struct SettingsBodyView: View {
    var firstNameIsFocused: FocusState<Bool>.Binding
    var lastNameIsFocused: FocusState<Bool>.Binding
    var passwordIsFocused: FocusState<Bool>.Binding
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                Spacer()
                    .frame(height: 80)
                SettingsInfoView()
                Spacer()
                    .frame(height: 16)
                SettingsFieldsView(
                    firstNameIsFocused: self.firstNameIsFocused,
                    lastNameIsFocused: self.lastNameIsFocused
                )
                Spacer()
                    .frame(height: 16)
                SettingsButtonView()
                SettingsTilesView(
                    passwordIsFocused: self.passwordIsFocused
                )
                Spacer()
                    .frame(height: 74)
            }
            .padding(
                [.horizontal],
                20
            )
        }
        .background(.white)
    }
}
