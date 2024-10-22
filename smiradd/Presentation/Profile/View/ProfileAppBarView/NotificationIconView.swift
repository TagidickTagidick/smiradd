import SwiftUI

struct NotificationIconView: View {
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    var action: (() -> ())
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            Image("notifications")
            if self.commonViewModel.notificationsModel != nil && !self.commonViewModel.notificationsModel!.items.filter({
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
                        self.commonViewModel.notificationsModel!.items.filter {
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
            self.action()
        }
    }
}
