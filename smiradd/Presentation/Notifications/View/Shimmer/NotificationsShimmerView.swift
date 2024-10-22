import SwiftUI
import Shimmer

struct NotificationsShimmerView: View {
    var body: some View {
        VStack (alignment: .leading) {
            NotificationsTileViewMock()
            NotificationsTileViewMock()
            NotificationsTileViewMock()
            NotificationsTileViewMock()
            NotificationsTileViewMock()
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
        .background(.white)
    }
}
