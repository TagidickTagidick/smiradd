import SwiftUI

struct TeamPageView: View {
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @StateObject private var viewModel: TeamViewModel
    
    init(
        repository: ITeamRepository,
        commonRepository: ICommonRepository,
        navigationService: NavigationService,
        teamId: String,
        teamType: CardType,
        commonViewModel: CommonViewModel
    ) {
        _viewModel = StateObject(
            wrappedValue: TeamViewModel(
                repository: repository,
                commonRepository: commonRepository,
                navigationService: navigationService,
                teamId: teamId,
                teamType: teamType,
                commonViewModel: commonViewModel
            )
        )
    }
    
    var body: some View {
        ZStack (alignment: .top) {
            if self.viewModel.pageType == .loading {
                CardShimmerView()
            }
            else {
                if self.viewModel.teamType == .editCard || self.viewModel.teamType == .newCard {
                    TeamEditView()
                }
                else {
                    TeamBodyView()
                }
            }
        }
        .ignoresSafeArea()
        .frame(
            width: UIScreen.main.bounds.width
        )
        .background(.white)
        .environmentObject(self.viewModel)
        .customAlert(
                        "У вас уже есть команда",
                        isPresented: $viewModel.isExitTeam,
                        actionText: "Покинуть"
                    ) {
                        self.commonViewModel.leaveAndLike()
                    } message: {
                        Text("Чтобы подавать заявку в эту команду вы должны покинуть текущую")
                            .font(
                                .custom(
                                    "OpenSans-Regular",
                                    size: 14
                                )
                            )
                            .foregroundStyle(textDefault)
                    }
                    .customAlert(
                                    "Вы уже - лидер команды",
                                    isPresented: $viewModel.isDeleteTeam,
                                    actionText: "Удалить"
                                ) {
                                    self.commonViewModel.leaveAndLike()
                                } message: {
                                    Text("Чтобы подавать заявку в эту команду вы должны удалить свою")
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
