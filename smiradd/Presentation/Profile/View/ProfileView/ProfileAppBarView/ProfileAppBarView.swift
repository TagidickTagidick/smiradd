import SwiftUI

struct ProfileAppBarView: View {
    let viewModel: ProfileViewModel
    @Binding var isNotifications: Bool
    @Binding var isSettings: Bool
    
    var body: some View {
        HStack (alignment: .center) {
            Text("Профиль")
                .font(
                    .custom(
                        "OpenSans-SemiBold",
                        size: 24
                    )
                )
                .foregroundStyle(textDefault)
            Spacer()
            NotificationIconView(
                viewModel: self.viewModel,
                isNotifications: self.$isNotifications
            )
            Spacer()
                .frame(width: 24)
            SettingsIconView(
                viewModel: self.viewModel,
                isSettings: self.$isSettings
            )
        }
    }
}
