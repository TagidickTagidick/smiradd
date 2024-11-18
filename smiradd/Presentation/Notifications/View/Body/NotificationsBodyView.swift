import SwiftUI

struct NotificationsBodyView: View {
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    var onDecline: ((String) -> ())
    var onAccept: ((String) -> ())
    var onTap: ((String, Bool) -> ())
    var onRefresh: (() -> ())
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                ForEach(self.commonViewModel.notificationsModel!.items) {
                    notificationModel in
                    NotificationsTileView(
                        notificationModel: notificationModel,
                        onDecline: {
                            id in
                            self.onDecline(id)
                        },
                        onAccept: {
                            id in
                            self.onAccept(id)
                        }
                    )
                    .onTapGesture {
                        self.onTap(
                            notificationModel.data.uuid_sender,
                            notificationModel.type == "team_request_answer"
                        )
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
