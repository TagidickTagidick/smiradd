import SwiftUI

struct NotificationsPageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject private var viewModel: ProfileViewModel
    
    @State private var nothingHere = PageType.nothingHereNotifications
    
    var body: some View {
        ZStack {
            if self.viewModel.notificationsModel!.items.isEmpty {
                VStack {
                    CustomAppBarView(
                        title: "Уведомления",
                        action: {
                            self.presentationMode.wrappedValue.dismiss()
                            self.viewModel.closeNotifications()
                        }
                    )
                    Spacer()
                        .frame(height: 12)
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
                        CustomAppBarView(
                            title: "Уведомления",
                            action: {
                                self.presentationMode.wrappedValue.dismiss()
                                self.viewModel.closeNotifications()
                            }
                        )
                        Spacer()
                            .frame(height: 12)
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
        }
        .padding(
            [.horizontal],
            20
        )
        .background(self.viewModel.notificationsModel!.items.isEmpty ? accent50 : .white)
        .navigationBarBackButtonHidden(true)
    }
}
