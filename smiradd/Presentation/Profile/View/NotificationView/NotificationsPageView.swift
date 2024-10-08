import SwiftUI

struct NotificationsPageView: View {
    @EnvironmentObject private var viewModel: ProfileViewModel
    
    var body: some View {
        ZStack (alignment: .top) {
            if self.viewModel.notificationsPageType == .loading {
                NotificationsShimmerView()
            }
            else {
                if self.viewModel.notificationsModel!.items.isEmpty {
                    NotificationsPlaceholderView()
                }
                else {
                    NotificationsBodyView()
                }
            }
            CustomAppBarView(
                title: "Уведомления",
                action: {
                    //self.presentationMode.wrappedValue.dismiss()
                    self.viewModel.closeNotifications()
                }
            )
            .padding(
                [.horizontal],
                20
            )
            .background(
                self.viewModel.notificationsModel == nil
                ? accent50
                : self.viewModel.notificationsModel!.items.isEmpty
                ? accent50
                : .white
            )
        }
        .navigationBarBackButtonHidden(true)
        .background(
            self.viewModel.notificationsModel == nil
                    ? accent50
                    : self.viewModel.notificationsModel!.items.isEmpty
            ? accent50
            : .white
        )
    }
}
