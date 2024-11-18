import SwiftUI

struct NotificationsPlaceholderView: View {
    
    var body: some View {
        VStack {
            Spacer()
            PageInfoView(
                pageType: PageType.nothingHereNotifications,
                onTap: {
                    //self.viewModel.closeNotifications()
                }
            )
            Spacer()
        }
        .background(accent50)
    }
}
