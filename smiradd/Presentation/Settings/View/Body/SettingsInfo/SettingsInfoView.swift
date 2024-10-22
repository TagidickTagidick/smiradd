import SwiftUI

struct SettingsInfoView: View {
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                SettingsAvatarView()
                Spacer()
                    .frame(height: 16)
                CustomTextView(text: self.commonViewModel.profileModel?.email ?? "")
            }
            Spacer()
        }
    }
}
