import SwiftUI

struct NotificationsPageView: View {
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @StateObject private var viewModel: NotificationsViewModel
    
    @Namespace var topID
    
    init(
        repository: INotificationsRepository,
        commonRepository: CommonRepository,
        commonViewModel: CommonViewModel,
        navigationService: NavigationService
    ) {
        _viewModel = StateObject(
            wrappedValue: NotificationsViewModel(
                repository: repository,
                navigationService: navigationService,
                commonViewModel: commonViewModel,
                commonRepository: commonRepository
            )
        )
    }
    
    var body: some View {
        ScrollViewReader {
            scrollView in
            ZStack (alignment: .top) {
                if self.viewModel.pageType == .loading {
                    NotificationsShimmerView()
                }
                else {
                    if self.commonViewModel.notificationsModel!.items.isEmpty {
                        NotificationsPlaceholderView()
                    }
                    else {
                        NotificationsBodyView(
                            onAccept: {
                                id in
                                self.viewModel.accept(
                                    id: id,
                                    accepted: false
                                )
                            },
                            onTap: {
                                id in
                                self.viewModel.openUserCard(
                                    id: id
                                )
                            },
                            onRefresh: {
                                self.viewModel.getNotifications()
                            }
                        )
                        .id(topID)
                    }
                }
                CustomAppBarView(
                    title: "Уведомления"
                )
                .padding(
                    [.horizontal],
                    20
                )
                .background(
                    self.commonViewModel.notificationsModel!.items.isEmpty
                    ? accent50
                    : .white
                )
                .onTapGesture {
                    scrollView.scrollTo(topID)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(
            self.commonViewModel.notificationsModel!.items.isEmpty
            ? accent50
            : .white
        )
    }
}
