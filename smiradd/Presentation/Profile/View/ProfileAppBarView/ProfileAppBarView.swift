import SwiftUI
import Shimmer

struct ProfileAppBarView: View {
    var onTapNotifications: (() -> ())
    var onTapSettings: (() -> ())
    
    var body: some View {
        HStack (alignment: .center) {
            CustomTitleView(
                text: "Избранное"
            )
            Spacer()
            NotificationIconView(
                action: {
                    self.onTapNotifications()
                }
            )
            Spacer()
                .frame(width: 24)
            SettingsIconView(
                action: {
                    self.onTapSettings()
                }
            )
        }
    }
}
