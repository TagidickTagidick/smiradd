import SwiftUI

class TeamViewModel: ObservableObject {
    @Published var pageType: PageType = .matchNotFound
    
    @Published var teamMainModel: TeamMainModel = TeamMainModel.mock
    
    @Published var logo: UIImage?
    @Published var logoVideoUrl: URL?
    @Published var logoUrl: String = ""
    
    @Published var name: String = ""
    
    @Published var aboutTeam: String = ""
    
    @Published var aboutProject: String = ""
    
    @Published var templatesOpened: Bool = false
    @Published var templatesPageType: PageType = .loading
    
    @Published var isAlert: Bool = false
    @Published var isLeave: Bool = false
    @Published var isKick: Bool = false
    @Published var isExitTeam: Bool = false
    @Published var isDeleteTeam: Bool = false
    
    @Published var noCardsSheet: Bool = false
    
    let teamId: String
    
    var kickId: String = ""
    
    @Published var teamType: CardType
    
    private let repository: ITeamRepository
    private let commonRepository: ICommonRepository
    private let navigationService: NavigationService
    private let commonViewModel: CommonViewModel
    
    init(
        repository: ITeamRepository,
        commonRepository: ICommonRepository,
        navigationService: NavigationService,
        teamId: String,
        teamType: CardType,
        commonViewModel: CommonViewModel
    ) {
        self.repository = repository
        self.commonRepository = commonRepository
        self.navigationService = navigationService
        self.teamId = teamId
        self.teamType = teamType
        self.commonViewModel = commonViewModel
        
        if self.teamType == .editCard {
            self.getMyTeam()
        }
        else if self.teamType != .newCard {
            self.getTeam()
        }
    }
    
    private func getMyTeam() {
        self.pageType = .loading
        
        self.repository.getMyTeam() {
            [self] result in
            DispatchQueue.main.async {
                self.pageType = .matchNotFound
                switch result {
                case .success(let teamMainModel):
                    self.teamMainModel = teamMainModel
                    self.initFields()
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
                
                self.pageType = .matchNotFound
            }
        }
    }
    
    private func getTeam() {
        self.pageType = .loading
        
        self.repository.getTeam(id: self.teamId) {
            [self] result in
            DispatchQueue.main.async {
                self.pageType = .matchNotFound
                switch result {
                case .success(let teamMainModel):
                    self.teamMainModel = teamMainModel
                    self.initFields()
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
                
                self.pageType = .matchNotFound
            }
        }
    }
    
    private func initFields() {
        self.name = self.teamMainModel.team.name
        self.aboutTeam = self.teamMainModel.team.about_team ?? ""
        self.aboutProject = self.teamMainModel.team.about_project ?? ""
        self.logoUrl = self.teamMainModel.team.team_logo ?? ""
    }
    
    func openTemplates() {
        self.templatesOpened = true
    }
    
    func closeTemplates(id: String) {
        self.templatesOpened = false
        
        if (id.isEmpty) {
            return
        }
        
        self.teamMainModel.team.bc_template_type = id
    }
    
    func startSave() {
        self.pageType = .loading
        
        self.uploadLogo()
    }
    
    private func uploadLogo() {
        if (logo == nil) {
            self.saveTeam()
            return
        }
        
        self.commonRepository.uploadImage(image: logo!) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    self.logoUrl = url
                    self.saveTeam()
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    }
    
    private func saveTeam() {
            if self.teamType == .editCard {
                self.repository.putTeam(
                    name: self.name,
                    aboutTeam: self.aboutTeam,
                    aboutProject: self.aboutProject,
                    teamLogo: self.logoUrl,
                    inviteUrl: self.teamMainModel.team.invite_url,
                    bcTemplateType: self.teamMainModel.team.bc_template_type ?? ""
                ) {
                    [self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let detailsModel):
                            print("success")
                            self.pageType = .matchNotFound
                            
                            self.navigationService.navigateBack()
                            
                            break
                        case .failure(let error):
                            print(error)
                            break
                        }
                    }
                }
            }
            else {
                self.repository.postTeam(
                    name: self.name,
                    aboutTeam: self.aboutTeam,
                    aboutProject: self.aboutProject,
                    teamLogo: self.logoUrl,
                    bcTemplateType: self.teamMainModel.team.bc_template_type ?? ""
                ) {
                    [self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let teamModel):
                            self.pageType = .matchNotFound
                            
                            self.commonViewModel.teamMainModel = TeamMainModel(
                                team: teamModel,
                                owner_card_id: "",
                                teammates: self.commonViewModel.cards
                            )
                            
                            self.navigationService.navigateBack()
                            
                            break
                        case .failure(let error):
                            print(error)
                            break
                        }
                    }
                }
            }
        }
    
    func openAlert() {
        self.isAlert = true
    }
    
    func openCard(id: String) {
        self.navigationService.navigate(
            to: .cardScreen(
                cardId: id,
                cardType: self.commonViewModel.cards.first(
                    where: {
                        $0.id == id
                    }
                ) == nil ? .favoriteCard : .myCard
            )
        )
    }
    
    func deleteTeam() {
        self.isAlert = false
        
        self.pageType = .loading
        
        self.commonRepository.deleteTeam() {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let teamMainModel):
                    self.commonViewModel.teamMainModel = nil
                    self.navigationService.navigateBack()
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
                
                self.pageType = .matchNotFound
            }
        }
    }
    
    func createCard() {
        self.noCardsSheet = false
        
        self.navigationService.navigateBack()
        
        self.navigationService.navigate(
            to: .profileScreen
        )
        
        self.navigationService.navigate(
            to: .cardScreen(
                cardId: "",
                cardType: .newCard
            )
        )
    }
    
    func like() {
        if self.commonViewModel.cards.isEmpty {
            self.noCardsSheet = true
            return
        }
        
        if self.commonViewModel.isTeamStorage {
            if self.commonViewModel.teamMainModel == nil {
                self.commonRepository.postRequest(
                    id: self.teamId
                ) {
                    [self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_):
                            self.commonViewModel.showAlert()
                            self.navigationService.navigateBack()
                            self.commonViewModel.teamViews.removeLast()
                            break
                        case .failure(_):
                            break
                        }
                    }
                }
            }
            else {
                if self.commonViewModel.cards.first(
                    where: {
                        $0.id == self.commonViewModel.teamMainModel!.owner_card_id!
                    }
                ) == nil {
                    self.isExitTeam = true
                }
                else {
                    self.isDeleteTeam = true
                }
            }
        }
        else {
            if self.commonViewModel.teamMainModel == nil {
                self.commonRepository.postFavorites(
                    cardId: self.teamId
                ) {
                    [self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_):
                            self.commonViewModel.cardViews.removeLast()
                            self.navigationService.navigateBack()
                            break
                        case .failure(let error):
                            break
                        }
                    }
                }
            }
            else {
                if self.commonViewModel.cards.first(
                    where: {
                        $0.id == self.commonViewModel.teamMainModel!.owner_card_id!
                    }
                ) == nil {
                    self.commonRepository.postFavorites(
                        cardId: self.teamId
                    ) {
                        [self] result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(_):
                                self.commonViewModel.cardViews.removeLast()
                                self.navigationService.navigateBack()
                                break
                            case .failure(let error):
                                break
                            }
                        }
                    }
                }
                else {
                    self.commonRepository.postTeamInvite(
                        id: self.teamId
                    ) {
                        [self] result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(_):
                                self.commonViewModel.cardViews.removeLast()
                                self.commonViewModel.showAlert()
                                self.navigationService.navigateBack()
                                break
                            case .failure(let error):
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    func leaveAndLike() {
        self.commonRepository.deleteLeaveTeam() {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.commonViewModel.teamMainModel = nil
                    self.like()
                    break
                case .failure(_):
                    self.navigationService.navigateBack()
                    break
                }
            }
        }
    }
    
    func deleteAndLike() {
        self.commonRepository.deleteTeam() {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.commonViewModel.teamMainModel = nil
                    self.like()
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
                
                self.pageType = .matchNotFound
            }
        }
    }
    
    func dislike(id: String) {
        if self.teamType == .editCard {
            if self.teamMainModel.owner_card_id != id {
                self.isKick = true
                self.kickId = id
            }
        }
        else {
            self.navigationService.navigateBack()
        }
    }
    
    func kick() {
        self.repository.postKick(
            id: self.kickId
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.teamMainModel.teammates.removeAll(
                        where: {
                            teammate in
                            teammate.id == self.kickId
                        }
                    )
                    self.commonViewModel.teamMainModel = self.teamMainModel
                    self.kickId = ""
                    break
                case .failure(_):
                    // Handle error
                    break
                }
                
                self.pageType = .matchNotFound
            }
        }
    }
    
    func openLeaveAlert() {
        self.isLeave = true
    }
    
    func leave() {
        self.isLeave = false
        
        self.commonRepository.deleteLeaveTeam() {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.commonViewModel.teamMainModel = nil
                    self.navigationService.navigateBack()
                    break
                case .failure(let error):
                    self.navigationService.navigateBack()
                    break
                }
                self.pageType = .pageNotFound
            }
        }
    }
}
