import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var pageType: PageType = .loading
    
    @Published var isTeamLoding: Bool = true
    
    @Published var templates: [TemplateModel] = []
    
    @Published var isSheet: Bool = false
    
    private let repository: IProfileRepository
    private let commonRepository: ICommonRepository
    let navigationService: NavigationService
    private let commonViewModel: CommonViewModel
    
    init(
        repository: IProfileRepository,
        commonRepository: ICommonRepository,
        navigationService: NavigationService,
        commonViewModel: CommonViewModel
    ) {
        self.repository = repository
        self.commonRepository = commonRepository
        self.navigationService = navigationService
        self.commonViewModel = commonViewModel
        self.getProfile()
    }
    
    func getProfile() {
        self.pageType = .loading
        
        self.repository.getProfile {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileModel):
                    self.commonViewModel.profileModel = profileModel
                case .failure(let error):
                    print(error)
                    break
                }
                self.getNotifications()
            }
        }
    }
    
    private func getNotifications() {
        self.commonRepository.getNotifications() {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let notificationsModel):
                    self.commonViewModel.notificationsModel = notificationsModel
                case .failure(let error):
                    print(error)
                    break
                }
                self.getCards()
            }
        }
    }
    
    private func getCards() {
        self.commonRepository.getCards {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cardModels):
                    self.commonViewModel.myCards = cardModels
                case .failure(let error):
                    print(error)
                    break
                }
                self.getTeam()
            }
        }
    }
    
    private func getTeam() {
        self.commonRepository.getTeam {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let teamMainModel):
                    self.commonViewModel.myTeamMainModel = teamMainModel
                case .failure(let error):
                    print(error)
                    break
                }
                self.pageType = .matchNotFound
            }
        }
    }
    
    func openNotifications() {
        print("ывровыр")
        self.navigationService.navigate(
            to: .notificationsScreen
        )
    }
    
    func openSettings() {
        self.navigationService.navigate(
            to: .settingsScreen
        )
    }
    
    func openNewCard() {
        self.isSheet = false
        
        self.navigationService.navigate(
            to: .cardScreen(
                cardId: "",
                cardType: .newCard
            )
        )
    }
    
    func openExistingCard(id: String) {
        self.navigationService.navigate(
            to: .cardScreen(
                cardId: id,
                cardType: .myCard
            )
        )
    }
    
    func openNewTeam() {
        if self.commonViewModel.myCards.isEmpty {
            self.isSheet = true
            return
        }
        
        self.navigationService.navigate(
            to: .teamScreen(
                teamId: "",
                teamType: .newCard
            )
        )
    }
    
    func openExistingTeam(id: String) {
        self.navigationService.navigate(
            to: .teamScreen(
                teamId: id,
                teamType: .myCard
            )
        )
    }
}
