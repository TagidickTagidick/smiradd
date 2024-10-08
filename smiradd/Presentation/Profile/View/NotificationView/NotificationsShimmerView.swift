import SwiftUI
import Shimmer

struct NotificationsShimmerView: View {
    var body: some View {
        VStack (alignment: .leading) {
            NotificationsTileView(
                notificationModel: NotificationModel.mock
            )
            NotificationsTileView(
                notificationModel: NotificationModel.mock
            )
            NotificationsTileView(
                notificationModel: NotificationModel.mock
            )
            NotificationsTileView(
                notificationModel: NotificationModel.mock
            )
            NotificationsTileView(
                notificationModel: NotificationModel.mock
            )
        }
        .padding(
            [.horizontal],
            20
        )
        .padding(
            [.top],
            60
        )
        .redacted(
            reason: .placeholder
        )
        .shimmering()
    }
}
