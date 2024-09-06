import SwiftUI

struct NotificationsPageView: View {
    @EnvironmentObject var router: NavigationService
    
    @EnvironmentObject private var viewModel: ProfileViewModel
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                CustomAppBar(title: "Уведомления")
                Spacer()
                    .frame(height: 12)
                ForEach(self.viewModel.notificationsModel!.items) { notificationModel in
                    VStack (alignment: .leading) {
                        Spacer()
                            .frame(height: 17)
                        HStack {
                            ZStack (alignment: .bottomTrailing) {
                                if notificationModel.avatar_url == nil {
                                    Image("avatar")
                                        .resizable()
                                        .frame(
                                            width: 52,
                                            height: 52
                                        )
                                        .clipShape(Circle())
                                }
                                else {
                                    AsyncImage(
                                        url: URL(
                                            string: notificationModel.avatar_url!
                                        )
                                    ) { image in
                                        image
                                            .resizable()
                                            .frame(
                                                width: 52,
                                                height: 52
                                            )
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                    }
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
                                Text(notificationModel.first_name! + " " + notificationModel.last_name!)
                                    .font(
                                        .custom(
                                            "OpenSans-SemiBold",
                                            size: 20
                                        )
                                    )
                                    .foregroundStyle(textDefault)
                                Spacer()
                                    .frame(height: 8)
                                Text(CustomFormatter.convertDateString(notificationModel.created_at))
                                    .font(
                                        .custom(
                                            "OpenSans-Regular",
                                            size: 16
                                        )
                                    )
                                    .foregroundStyle(textAdditional)
                            }
                        }
                        Spacer()
                            .frame(width: 16)
                        Text(notificationModel.text)
                            .font(
                                .custom(
                                    "OpenSans-Regular",
                                    size: 16
                                )
                            )
                            .foregroundStyle(textDefault)
                    }
                }
            }
            .padding(
                [.horizontal],
                20
            )
        }
        .background(.white)
        .onAppear {
            if self.viewModel.notificationsModel != nil {
                for notificationModel in self.viewModel.notificationsModel!.items {
                    if notificationModel.status != "READED" {
                        makeRequest(
                            path: "notification/\(notificationModel.id)",
                            method: .patch,
                            isString: true
                        ) { (result: Result<DeleteModel, Error>) in
                            switch result {
                            case .success(let notificationsModel):
                                print("success")
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
    }
}
