import SwiftUI
import Shimmer

struct ProfileInfoView: View {
    let isProfileLoading: Bool
    let pictureUrl: String
    let firstName: String
    let lastName: String
    let email: String
    
    var body: some View {
        HStack {
            ProfileAvatarView(pictureUrl: pictureUrl)
            Spacer()
                .frame(width: 16)
            VStack (alignment: .leading) {
                Text("\(self.firstName) \(self.lastName)")
                    .font(
                        .custom(
                            "OpenSans-SemiBold",
                            size: 22
                        )
                    )
                    .foregroundStyle(textDefault)
                Spacer()
                    .frame(height: 12)
                Text(self.email)
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
        .redacted(
            reason: self.isProfileLoading
            ? .placeholder
            : .invalidated
        )
        .shimmering(active: self.isProfileLoading)
    }
}
