import SwiftUI

struct SettingsInfoView: View {
    @EnvironmentObject private var viewModel: ProfileViewModel
    
    @Binding var avatar: UIImage?
    @Binding var avatarUrl: String
    @Binding var videoUrl: URL?
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                SettingsAvatarView(
                    image: $avatar,
                    imageUrl: $avatarUrl,
                    videoUrl: $videoUrl
                )
                Spacer()
                    .frame(height: 16)
                CustomTextView(text: self.viewModel.profileModel?.email ?? "")
            }
            Spacer()
        }
    }
}
