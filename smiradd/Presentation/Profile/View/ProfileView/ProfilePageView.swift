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
                            Spacer()
                                .frame(height: 16)
                            ProfileInfoView(
                                isProfileLoading: self.viewModel.isProfileLoading,
                                pictureUrl: self.viewModel.profileModel?.picture_url ?? "",
                                firstName: self.viewModel.profileModel?.first_name ?? "",
                                lastName: self.viewModel.profileModel?.last_name ?? "",
                                email: self.viewModel.profileModel?.email ?? ""
                            )
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
                            }
                        )
                        Spacer()
                            .frame(height: 78)
                    }
                }
        }
        .background(accent50)
        .customAlert(
            "Создайте визитку",
            isPresented: $viewModel.isSheet,
            actionText: "Да",
            isRed: false
        ) {
            self.viewModel.openNewCard()
        } message: {
            Text("Вы должны создать свою визитку, чтобы открыть возможность создавать команду. Хотите сделать это сейчас?")
                .font(
                    .custom(
                        "OpenSans-Regular",
                        size: 14
                    )
                )
                .foregroundStyle(textDefault)
        }
    }
}
