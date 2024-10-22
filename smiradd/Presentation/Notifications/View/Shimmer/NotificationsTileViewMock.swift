import SwiftUI

struct NotificationsTileViewMock: View {
    var body: some View {
        NotificationsTileView(
            notificationModel: NotificationModel.mock,
            onAccept: {
                _ in
            }
        )
    }
}
