import SwiftUI
import SDWebImageSwiftUI

struct CardServiceView: View {
    var service: ServiceModel
    
    var body: some View {
        ZStack (alignment: .topTrailing) {
            if self.service.coverImage != nil {
                Image(
                    uiImage: service.coverImage!
                )
                    .resizable()
            }
            else if self.service.coverVideo != nil {
                WebImage(
                    url: self.service.coverVideo
                ) { image in
                        image
                        .resizable()
                    } placeholder: {
                        EmptyView()
                    }
            }
            else if !(self.service.cover_url ?? "").isEmpty {
                WebImage(
                    url: URL(
                        string: self.service.cover_url!
                    )
                ) { image in
                        image
                        .resizable()
                    } placeholder: {
                        EmptyView()
                    }
            }
            else {
                Image("avatar")
                    .resizable()
            }
            VStack (alignment: .trailing) {
                if service.price != nil {
                    ZStack {
                        Text(String(service.price!))
                            .font(
                                .custom(
                                    "OpenSans-SemiBold",
                                    size: 16
                                )
                            )
                            .foregroundStyle(.white)
                    }
                    .padding(
                        [.vertical],
                        8
                    )
                    .padding(
                        [.horizontal],
                        20
                    )
                    .background(textDefault.opacity(0.8))
                    .cornerRadius(12)
                    .offset(x: -16, y: 16)
                }
                Spacer()
                VStack (alignment: .leading) {
                    Text(self.service.name)
                        .font(
                            .custom(
                                "OpenSans-SemiBold",
                                size: 16
                            )
                        )
                        .foregroundStyle(.white)
                    Spacer()
                        .frame(height: 8)
                    Text(self.service.description ?? "")
                        .font(
                            .custom(
                                "OpenSans-Regular",
                                size: 14
                            )
                        )
                        .foregroundStyle(.white)
                }
                .padding(
                    [.vertical, .horizontal],
                    16
                )
                .frame(
                    width: 240,
                    height: 92
                )
                .background(textDefault.opacity(0.8))
            }
        }
        .frame(
            width: 240,
            height: 192
        )
        .cornerRadius(12)
    }
}
