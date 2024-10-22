import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct ProfileAvatarView: View {
    let pictureUrl: String
    
    var body: some View {
        if self.pictureUrl.isEmpty {
            Image("avatar")
                .resizable()
                .frame(
                    width: 64,
                    height: 64
                )
                .clipShape(Circle())
        }
        else {
            WebImage(
                url: URL(
                    string: self.pictureUrl
                )
            ) { image in
                    image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: 64,
                        height: 64
                    )
                    .clipped()
                    .clipShape(Circle())
                } placeholder: {
                        Rectangle().foregroundColor(.gray)
                }
                .frame(
                    width: 52,
                    height: 52
                )
                .clipShape(Circle())
        }
    }
}
