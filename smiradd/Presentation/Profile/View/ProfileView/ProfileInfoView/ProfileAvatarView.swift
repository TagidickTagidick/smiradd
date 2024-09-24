import SwiftUI

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
            AsyncImage(
                url: URL(
                    string: self.pictureUrl
                )
            ) { image in
                image
                    .resizable()
                    .frame(
                        width: 64,
                        height: 64
                    )
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
        }
    }
}
