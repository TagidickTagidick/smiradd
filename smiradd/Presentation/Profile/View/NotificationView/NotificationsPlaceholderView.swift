import SwiftUI

struct NotificationsPlaceholderView: View {
    
    @EnvironmentObject private var viewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            Spacer()
            PageInfoView(
                pageType: self.viewModel.pageType,
                onTap: {
                    self.viewModel.closeNotifications()
                }
            )
            Spacer()
        }
        .background(accent50)
    }
}
