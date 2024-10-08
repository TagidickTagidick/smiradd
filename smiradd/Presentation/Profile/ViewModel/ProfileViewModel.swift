import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var pageType: PageType = .loading
    @Published var notificationsPageType: PageType = .loading
    
    @Published var profileModel: ProfileModel?
    
    @Published var isTeamLoding: Bool = true
    
    @Published var notificationsModel: NotificationsModel?
    
    @Published var templates: [TemplateModel] = []
    
    @Published var isNotifications: Bool = false
    
    @Published var isSettings: Bool = false
    @Published var settingsPageType: PageType = .matchNotFound
    
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
                    self.profileModel = profileModel
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
                    self.commonViewModel.cards = cardModels
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
                    self.commonViewModel.teamMainModel = teamMainModel
                case .failure(let error):
                    print(error)
                    break
                }
                self.pageType = .matchNotFound
                self.getNotifications()
            }
        }
    }
    
    func getNotifications() {
        self.notificationsPageType = .loading
        
        Task {
            try? await Task.sleep(nanoseconds: 1000000000)
            
            self.repository.getNotifications {
                [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let notificationsModel):
                        self.notificationsModel = notificationsModel
                        
                        if self.notificationsModel!.items.isEmpty {
                            self.notificationsPageType = .nothingHereNotifications
                        }
                        else {
                            self.notificationsPageType = .matchNotFound
                        }
                        break
                    case .failure(let error):
                        if error.message == "Превышен лимит времени на запрос." || error.message == "Вероятно, соединение с интернетом прервано." {
                            self.notificationsPageType = .noResultsFound
                        }
                        else {
                            self.notificationsPageType = .somethingWentWrong
                        }
                        break
                    }
                }
            }
        }
    }
    
    func deleteAccount() {
        self.repository.deleteProfile {
            [self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    UserDefaults.standard.removeObject(forKey: "access_token")
                    UserDefaults.standard.removeObject(forKey: "refresh_token")
                    self.navigationService.navigateToRoot()
                    self.navigationService.navigate(to: .signInScreen)
                }
            case .failure(let errorModel):
                print("Signup failed:")
            }
        }
    }
    
    func openSettings() {
        self.settingsPageType = .matchNotFound
        self.isSettings = true
    }
    
    func startSaveSettings(
        pictureUrl: String,
        picture: UIImage?,
        firstName: String,
        lastName: String
    ) {
        self.settingsPageType = .loading
        
        if picture == nil {
            self.saveSettings(
                pictureUrl: pictureUrl,
                firstName: firstName,
                lastName: lastName
            )
            
            return
        }
        
        self.commonRepository.uploadImage(
            image: picture!
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    self.saveSettings(
                        pictureUrl: url,
                        firstName: firstName,
                        lastName: lastName
                    )
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    }
    
    private func saveSettings(
        pictureUrl: String,
        firstName: String,
        lastName: String
    ) {
        self.repository.patchProfile(
            pictureUrl: pictureUrl,
            firstName: firstName,
            lastName: lastName
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileModel):
                    if self.profileModel != nil {
                        self.profileModel!.picture_url = profileModel.picture_url
                        self.profileModel!.first_name = profileModel.first_name
                        self.profileModel!.last_name = profileModel.last_name
                    }
                    break
                case .failure(let error):
                    print(error)
                    break
                }
                self.isSettings = false
                self.settingsPageType = .matchNotFound
            }
        }
    }
    
    func closeSettings() {
        self.isSettings = false
    }
    
    func openNotifications() {
        self.isNotifications = true
        self.readNotifications()
    }
    
    private func readNotifications() {
        if self.notificationsModel == nil {
            return
        }
        
        for i in 0 ..< self.notificationsModel!.items.count {
            if self.notificationsModel!.items[i].status != "READED" {
                self.repository.patchNotification(
                    id: self.notificationsModel!.items[i].id,
                    accepted: self.notificationsModel!.items[i].accepted
                ) {_ in }
            }
            
            self.notificationsModel!.items[i].status = "READED"
        }
    }
    
    func closeNotifications() {
        self.isNotifications = false
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
        if self.commonViewModel.cards.isEmpty {
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
    
    func accept(id: String, accepted: Bool) {
        self.repository.patchNotification(
            id: id,
            accepted: accepted
        ) {
            result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.notificationsModel!.items[
                        self.notificationsModel!.items.firstIndex(
                        where: {
                            notification in
                            notification.id == id
                        }
                    )!
                    ].accepted = accepted
                    
                    if accepted {
                        var cardModel = CardModel.mock
                        cardModel.avatar_url = self.notificationsModel!.items.first(
                            where: {
                                notification in
                                notification.id == id
                            }
                        )?.data.avatar_url
                        if self.commonViewModel.teamMainModel != nil {
                            self.commonViewModel.teamMainModel!.teammates.append(CardModel.mock)
                        }
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func openUserCard(id: String) {
        self.navigationService.navigate(
            to: .cardScreen(
                cardId: id,
                cardType: .userCard
            )
        )
    }
}
