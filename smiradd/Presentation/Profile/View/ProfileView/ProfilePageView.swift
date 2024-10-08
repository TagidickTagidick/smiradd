import SwiftUI
import Shimmer

struct ProfilePageView: View {
    @EnvironmentObject var cardSettings: CardViewModel
    
    @EnvironmentObject var commonViewModel: CommonViewModel
    
    @StateObject var viewModel: ProfileViewModel
    
    init(
        repository: IProfileRepository,
        commonRepository: ICommonRepository,
        navigationService: NavigationService,
        commonViewModel: CommonViewModel
    ) {
        _viewModel = StateObject(
            wrappedValue: ProfileViewModel(
                repository: repository,
                commonRepository: commonRepository,
                navigationService: navigationService,
                commonViewModel: commonViewModel
            )
        )
    }
    
    var body: some View {
        ZStack {
                ScrollView {
                    VStack {
                        VStack {
                            ProfileAppBarView(
                                viewModel: self.viewModel,
                                isNotifications: $viewModel.isNotifications,
                                isSettings: $viewModel.isSettings
                            )
                            .redacted(
                                reason: self.viewModel.pageType == .loading ? .placeholder : .invalidated
                            )
                            .shimmering(active: self.viewModel.pageType == .loading)
                            Spacer()
                                .frame(height: 16)
                            ProfileInfoView(
                                pictureUrl: self.viewModel.profileModel?.picture_url ?? "",
                                firstName: self.viewModel.profileModel?.first_name ?? "",
                                lastName: self.viewModel.profileModel?.last_name ?? "",
                                email: self.viewModel.profileModel?.email ?? ""
                            )
                            .redacted(
                                reason: self.viewModel.pageType == .loading ? .placeholder : .invalidated
                            )
                            .shimmering(active: self.viewModel.pageType == .loading)
                            Spacer()
                                .frame(height: 28)
                        }
                        .padding(
                            [.horizontal],
                            20
                        )
                        MyCardsView(
                            createCard: {
                                self.viewModel.openNewCard()
                            },
                            openExistingCard: {
                                id in
                                self.viewModel.openExistingCard(id: id)
                            }
                        )
                        .redacted(
                            reason: self.viewModel.pageType == .loading ? .placeholder : .invalidated
                        )
                        .shimmering(active: self.viewModel.pageType == .loading)
                        Spacer()
                            .frame(height: 24)
                        MyTeamView(
                            createTeam: {
                                self.viewModel.openNewTeam()
                            },
                            openTeam: {
                                self.viewModel.openExistingTeam(
                                    id: self.commonViewModel.teamMainModel!.team.id!
                                )
                            },
                            isSheet: self.$viewModel.isSheet,
                            openNewCard: {
                                self.viewModel.openNewCard()
                            }
                        )
                        .redacted(
                            reason: self.viewModel.pageType == .loading ? .placeholder : .invalidated
                        )
                        .shimmering(active: self.viewModel.pageType == .loading)
                        Spacer()
                            .frame(height: 78)
                    }
                }
                .refreshable {
                    self.viewModel.getProfile()
                }
        }
        .background(accent50)
    }
}
