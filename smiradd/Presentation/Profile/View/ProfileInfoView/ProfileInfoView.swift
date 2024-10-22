import SwiftUI
import Shimmer

struct ProfileInfoView: View {
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    var body: some View {
        HStack {
            ProfileAvatarView(
                pictureUrl: self.commonViewModel.profileModel?.picture_url ?? ""
            )
            Spacer()
                .frame(width: 16)
            VStack (alignment: .leading) {
                Text("\(self.self.commonViewModel.profileModel?.first_name ?? "") \(self.commonViewModel.profileModel?.last_name ?? "")")
                    .font(
                        .custom(
                            "OpenSans-SemiBold",
                            size: 22
                        )
                    )
                    .foregroundStyle(textDefault)
                Spacer()
                    .frame(height: 12)
                Text(self.commonViewModel.profileModel?.email ?? "")
                    .font(
                        .custom(
                            "OpenSans-Regular",
                            size: 18
                        )
                    )
                    .foregroundStyle(textDefault)
            }
            Spacer()
        }
    }
}
