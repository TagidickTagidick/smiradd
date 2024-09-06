import SwiftUI

struct CardServiceView: View {
    var service: ServiceModelLocal
    
    var body: some View {
        ZStack (alignment: .topTrailing) {
            if service.cover == nil {
                AsyncImage(
                    url: URL(
                        string: service.coverUrl
                    )
                ) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
            }
            else {
                Image(uiImage: service.cover!)
                    .resizable()
            }
            VStack (alignment: .trailing) {
                if service.price != 0 {
                    ZStack {
                        Text(String(service.price))
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
                    Text(service.name)
                        .font(
                            .custom(
                                "OpenSans-SemiBold",
                                size: 16
                            )
                        )
                        .foregroundStyle(.white)
                    Spacer()
                        .frame(height: 8)
                    Text(service.description)
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
