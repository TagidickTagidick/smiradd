import SwiftUI

struct NotificationIconView: View {
    let viewModel: ProfileViewModel
    @Binding var isNotifications: Bool
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            Image("notifications")
            if self.viewModel.notificationsModel != nil && !self.viewModel.notificationsModel!.items.filter({
                $0.status != "READED"
            }).isEmpty {
                Circle()
                    .fill(Color(
                        red: 0.408,
                        green: 0.784,
                        blue: 0.58
                    ))
                    .frame(
                        width: 18,
                        height: 18
                    )
                Text(
                    String(
                        self.viewModel.notificationsModel!.items.filter {
                            $0.status != "READED"
                        }.count
                    )
                )
                    .font(
                        .custom(
                            "OpenSans-Bold",
                            size: 14
                        )
                    )
                    .foregroundStyle(textDefault)
                    .offset(x: 5)
            }
        }
        .onTapGesture {
            self.viewModel.openNotifications()
        }
        .navigationDestination(
            isPresented: self.$isNotifications
        ) {
            NotificationsPageView()
                .environmentObject(self.viewModel)
        }
    }
}
