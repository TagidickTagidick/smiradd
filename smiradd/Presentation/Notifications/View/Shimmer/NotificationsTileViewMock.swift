import SwiftUI

struct NotificationsTileViewMock: View {
    var body: some View {
        NotificationsTileView(
            notificationModel: NotificationModel.mock,
            onDecline: {
                _ in
            },
            onAccept: {
                _ in
            }
        )
    }
}
