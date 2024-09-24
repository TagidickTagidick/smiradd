import SwiftUI

struct SettingsIconView: View {
    let viewModel: ProfileViewModel
    @Binding var isSettings: Bool
    
    var body: some View {
        Image("settings")
            .onTapGesture {
                self.viewModel.openSettings()
            }
            .navigationDestination(
                isPresented: self.$isSettings
            ) {
                SettingsPageView(
                    repository: SettingsRepository(
                        networkService: NetworkService()
                    ),
                    firstName: self.viewModel.profileModel?.first_name ?? "",
                    lastName: self.viewModel.profileModel?.last_name ?? "",
                    avatarUrl: self.viewModel.profileModel?.picture_url ?? ""
                )
                .environmentObject(self.viewModel)
            }
    }
}
