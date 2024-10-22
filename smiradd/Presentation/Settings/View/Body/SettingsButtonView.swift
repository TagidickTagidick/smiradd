import SwiftUI

struct SettingsButtonView: View {
    @EnvironmentObject private var viewModel: SettingsViewModel
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    var body: some View {
        if self.viewModel.firstName != (self.commonViewModel.profileModel!.first_name ?? "") || self.viewModel.lastName != (self.commonViewModel.profileModel!.last_name ?? "") || self.viewModel.pictureImage != nil || self.viewModel.pictureVideo != nil {
            Spacer()
                .frame(height: 24)
            CustomButtonView(
                text: "Сохранить",
                color: Color(
                    red: 0.408,
                    green: 0.784,
                    blue: 0.58
                )
            )
            .onTapGesture {
                self.viewModel.startSaveSettings()
            }
        }
    }
}
