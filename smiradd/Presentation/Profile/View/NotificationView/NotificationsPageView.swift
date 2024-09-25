import SwiftUI

struct NotificationsPageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject private var viewModel: ProfileViewModel
    
    @State private var nothingHere = PageType.nothingHereNotifications
    
    var body: some View {
        ZStack (alignment: .top) {
            if self.viewModel.notificationsModel!.items.isEmpty {
                VStack {
                    Spacer()
                        .frame(height: 60)
                    CustomWidget(
                        pageType: self.$nothingHere,
                        onTap: {}
                    )
                }
                .background(accent50)
            }
            else {
                ScrollView {
                    VStack (alignment: .leading) {
                        Spacer()
                            .frame(height: 60)
                        ForEach(self.viewModel.notificationsModel!.items) {
                            notificationModel in
                            NotificationsTileView(
                                notificationModel: notificationModel
                            )
                        }
                    }
                }
                .background(.white)
            }
            CustomAppBarView(
                title: "Уведомления",
                action: {
                    self.presentationMode.wrappedValue.dismiss()
                    self.viewModel.closeNotifications()
                }
            )
            .background(self.viewModel.notificationsModel!.items.isEmpty ? accent50 : .white)
        }
        .padding(
            [.horizontal],
            20
        )
        .background(self.viewModel.notificationsModel!.items.isEmpty ? accent50 : .white)
        .navigationBarBackButtonHidden(true)
    }
}
