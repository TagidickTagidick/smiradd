import SwiftUI

struct NotificationsBodyView: View {
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    var onAccept: ((String) -> ())
    var onTap: ((String) -> ())
    var onRefresh: (() -> ())
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                ForEach(self.commonViewModel.notificationsModel!.items) {
                    notificationModel in
                    NotificationsTileView(
                        notificationModel: notificationModel,
                        onAccept: {
                            id in
                            self.onAccept(id)
                        }
                    )
                    .onTapGesture {
                        self.onTap(notificationModel.data.uuid_sender)
                    }
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
            self.onRefresh()
        }
    }
}
