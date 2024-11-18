import SwiftUI

class TeamViewModel: ObservableObject {
    @Published var pageType: PageType = .matchNotFound
    
    @Published var logoImage: UIImage?
    @Published var logoVideo: URL?
    @Published var logoUrl: String = ""
    
    @Published var name: String = ""
    
    @Published var aboutTeam: String = ""
    
    @Published var aboutProject: String = ""
    
    @Published var isEditTeammates: Bool = false
    
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
                    self.commonViewModel.teamMainModel = teamMainModel
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
                    self.commonViewModel.teamMainModel = teamMainModel
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
        self.name = self.commonViewModel.teamMainModel.team.name
        self.aboutTeam = self.commonViewModel.teamMainModel.team.about_team ?? ""
        self.aboutProject = self.commonViewModel.teamMainModel.team.about_project ?? ""
        self.logoUrl = self.commonViewModel.teamMainModel.team.team_logo ?? ""
    }
    
    func openTemplates() {
        self.navigationService.navigate(
            to: .templatesScreen(
                isTeam: true
            )
        )
    }
    
    func startSave() {
        self.pageType = .loading
        
        self.uploadLogo()
    }
    
    private func uploadLogo() {
        if self.logoImage != nil {
            self.commonRepository.uploadImage(image: self.logoImage!) {
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
        else if self.logoVideo != nil {
            self.commonRepository.uploadVideo(video: self.logoVideo!) {
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
        else {
            self.saveTeam()
        }
    }
    
    private func saveTeam() {
            if self.teamType == .editCard {
                self.repository.putTeam(
                    name: self.name,
                    aboutTeam: self.aboutTeam,
                    aboutProject: self.aboutProject,
                    teamLogo: self.logoUrl,
                    inviteUrl: self.commonViewModel.teamMainModel.team.invite_url,
                    bcTemplateType: self.commonViewModel.teamMainModel.team.bc_template_type ?? ""
                ) {
                    [self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let teamModel):
                            self.pageType = .matchNotFound
                            
                            self.commonViewModel.myTeamMainModel!.team.bc_template_type = teamModel.bc_template_type
                            self.commonViewModel.myTeamMainModel!.team.team_logo = teamModel.team_logo
                            self.commonViewModel.myTeamMainModel!.team.invite_url = teamModel.invite_url
                            self.commonViewModel.myTeamMainModel!.team.about_team = teamModel.about_team
                            self.commonViewModel.myTeamMainModel!.team.name = teamModel.name
                            self.commonViewModel.myTeamMainModel!.team.about_project = teamModel.about_project
                            
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
                    bcTemplateType: self.commonViewModel.teamMainModel.team.bc_template_type ?? ""
                ) {
                    [self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let teamModel):
                            self.pageType = .matchNotFound
                            
                            self.commonViewModel.myTeamMainModel = TeamMainModel(
                                team: teamModel,
                                owner_card_id: "",
                                teammates: [
                                    self.commonViewModel.myCards.first!
                                ]
                            )
                            
                            self.navigationService.navigateBack()
                            
                            break
                        case .failure(let error):
                            if error.message == "Team name already registrated" {
                                self.commonViewModel.showAlert(
                                    isError: true,
                                    text: "Такое название команды уже существует"
                                )
                            }
                            
                            self.pageType = .matchNotFound
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
                cardType: .userCard
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
                    self.commonViewModel.myTeamMainModel = nil
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
    
    func dislike(id: String) {
        if self.commonViewModel.teamMainModel.owner_card_id != id {
            self.isKick = true
            self.kickId = id
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
                    self.commonViewModel.teamMainModel.teammates.removeAll(
                        where: {
                            teammate in
                            teammate.id == self.kickId
                        }
                    )
                    self.commonViewModel.myTeamMainModel = self.commonViewModel.teamMainModel
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
                    self.commonViewModel.myTeamMainModel = nil
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
