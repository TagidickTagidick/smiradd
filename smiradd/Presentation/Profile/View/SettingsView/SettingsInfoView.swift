import SwiftUI

struct SettingsInfoView: View {
    @EnvironmentObject private var viewModel: ProfileViewModel
    
    @Binding var avatar: UIImage?
    @Binding var avatarUrl: String
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                SettingsAvatarView(
                    image: $avatar,
                    imageUrl: $avatarUrl
                )
                Spacer()
                    .frame(height: 16)
                Text(self.viewModel.profileModel?.email ?? "")
                    .font(
                        .custom(
                            "OpenSans-Regular",
                            size: 14
                        )
                    )
                    .foregroundStyle(textDefault)
            }
            Spacer()
        }
    }
}
