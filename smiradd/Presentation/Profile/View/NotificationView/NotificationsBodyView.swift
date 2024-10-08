import SwiftUI

struct NotificationsBodyView: View {
    
    @EnvironmentObject private var viewModel: ProfileViewModel
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                ForEach(self.viewModel.notificationsModel!.items) {
                    notificationModel in
                    NotificationsTileView(
                        notificationModel: notificationModel
                    )
                }
                .padding(
                    [.horizontal],
                    20
                )
            }
        }
        .padding(
            [.top],
            60
        )
        .background(.white)
        .refreshable {
            self.viewModel.getNotifications()
        }
    }
}
