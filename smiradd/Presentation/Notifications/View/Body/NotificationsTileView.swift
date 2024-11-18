import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct NotificationsTileView: View {
    let notificationModel: NotificationModel
    
    let onDecline: ((String) -> ())
    let onAccept: ((String) -> ())
    
    var body: some View {
        VStack (alignment: .leading) {
            Spacer()
                .frame(height: 17)
            HStack {
                ZStack (alignment: .bottomTrailing) {
                    if self.notificationModel.data.avatar_url == nil {
                        Image("avatar")
                            .resizable()
                            .frame(
                                width: 52,
                                height: 52
                            )
                            .clipShape(Circle())
                    }
                    else {
                        WebImage(
                            url: URL(
                                string: self.notificationModel.data.avatar_url!
                            )
                        ) { image in
                                image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(
                                    width: 52,
                                    height: 52
                                )
                                .clipped()
                            } placeholder: {
                                ProgressView()
                            }
                            .clipShape(Circle())
                    }
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.4))
                            .frame(
                                width: 24,
                                height: 24
                            )
                        Image(systemName: "heart.fill")
                            .foregroundColor(textDefault)
                            .frame(
                                width: 13,
                                height: 11.34
                            )
                    }
                }
                Spacer()
                    .frame(width: 16)
                VStack (alignment: .leading) {
                    Text(self.notificationModel.data.first_name + " " + self.notificationModel.data.last_name)
                        .font(
                            .custom(
                                "OpenSans-SemiBold",
                                size: 20
                            )
                        )
                        .foregroundStyle(textDefault)
                    Spacer()
                        .frame(height: 8)
                    Text(
                        CustomFormatter.convertDateString(
                            self.notificationModel.created_at
                        )
                    )
                        .font(
                            .custom(
                                "OpenSans-Regular",
                                size: 16
                            )
                        )
                        .foregroundStyle(textAdditional)
                }
                Spacer()
            }
            Spacer()
                .frame(width: 16)
            Text(self.notificationModel.data.text ?? "")
                .font(
                    .custom(
                        "OpenSans-Regular",
                        size: 16
                    )
                )
                .foregroundStyle(textDefault)
            Spacer()
                .frame(width: 16)
            if self.notificationModel.type == "team_request" || self.notificationModel.type == "team_invite" && self.notificationModel.accepted == nil {
                HStack {
                    ZStack {
                        Text("Отклонить")
                            .font(
                                .custom(
                                    "OpenSans-Regular",
                                    size: 16
                                )
                            )
                            .foregroundStyle(Color(red: 0.149, green: 0.153, blue: 0.196))
                    }
                    .padding(
                        [.horizontal],
                        20
                    )
                    .padding(
                        [.vertical],
                        8
                    )
                    .background(Color(red: 0.949, green: 0.949, blue: 0.949))
                    .cornerRadius(19)
                    .onTapGesture {
                        self.onDecline(notificationModel.id)
                    }
                    Spacer()
                        .frame(width: 16)
                    ZStack {
                        Text("Принять")
                            .font(
                                .custom(
                                    "OpenSans-Regular",
                                    size: 16
                                )
                            )
                            .foregroundStyle(.white)
                    }
                    .padding(
                        [.horizontal],
                        20
                    )
                    .padding(
                        [.vertical],
                        8
                    )
                    .background(Color(red: 0.408, green: 0.784, blue: 0.58))
                    .cornerRadius(19)
                    .onTapGesture {
                        self.onAccept(self.notificationModel.id)
                    }
                }
            }
        }
    }
}
