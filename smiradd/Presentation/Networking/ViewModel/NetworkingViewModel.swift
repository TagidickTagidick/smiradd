import SwiftUI

class NetworkingViewModel: ObservableObject {
    
    @Published var pageType: PageType = .loading
    
    @Published var isForumCodeSheet: Bool = false
    @Published var isFilterSheet: Bool = false
    
    @Published var pinCode: String = ""
    
    @Published var isQuestionForumSheet: Bool = false
    @Published var isChooseStatusSheet: Bool = false
    @Published var isExitNetworkingSheet: Bool = false
    @Published var isExitTeam: Bool = false
    @Published var isDeleteTeam: Bool = false
    @Published var currentTeamId: String = ""
    
    @Published var noCardsSheet: Bool = false
    
    private var forumCode: String? {
        return UserDefaults.standard.string(forKey: "forum_code")
    }
    
    @Published var isTeam: Bool = false
    
    private let repository: INetworkingRepository
    private let navigationService: NavigationService
    private let locationManager: LocationManager
    private let commonViewModel: CommonViewModel
    private let commonRepository: CommonRepository
    
    init(
        repository: INetworkingRepository,
        navigationService: NavigationService,
        locationManager: LocationManager,
        commonViewModel: CommonViewModel,
        commonRepository: CommonRepository
    ) {
        self.repository = repository
        self.navigationService = navigationService
        self.locationManager = locationManager
        self.commonViewModel = commonViewModel
        self.commonRepository = commonRepository
        self.commonViewModel.cardViews = []
        self.commonViewModel.teamViews = []
        self.isTeam = self.commonViewModel.isTeamStorage
        self.onInit()
    }
    
    func onInit() {
        self.commonViewModel.cardViews = []
        self.commonViewModel.teamViews = []
        
        if self.locationManager.location == nil {
            self.pageType = .shareLocation
            return
        }
        
        if !self.commonViewModel.forumName.isEmpty && !UserDefaults.standard.bool(forKey: "first_time_forum") {
            UserDefaults.standard.set(
                true,
                forKey: "first_time_forum"
            )
            
            self.isQuestionForumSheet = true
            
            return
        }
        
        if !UserDefaults.standard.bool(forKey: "first_time_forum") {
            UserDefaults.standard.set(
                true,
                forKey: "first_time_forum"
            )
        }
        
        self.getAroundMe()
    }
    
    func answerNoQuestionForumSheet() {
        self.isQuestionForumSheet = false
        self.pageType = .matchNotFound
    }
    
    func answerYesQuestionForumSheet() {
        self.isQuestionForumSheet = false
        self.isChooseStatusSheet = true
    }
    
    private func getAroundMe() {
        self.pageType = .loading
        
        self.commonViewModel.cardViews = []
        self.commonViewModel.teamViews = []
        
        if self.commonViewModel.isTeamStorage {
            self.repository.getAroundMeTeams(
                specificity: self.commonViewModel.networkingSpecificities,
                code: self.forumCode ?? ""
            ) {
                [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let teamModels):
                        for team in teamModels {
                            if self.commonViewModel.teamMainModel?.team.id != team.id {
                                self.commonViewModel.teamViews.append(
                                    SwipeTeamView(
                                        teamModel: team,
                                        onDislike: {
                                            self.dislike(id: team.id!)
                                        },
                                        onLike: {
                                            self.like(id: team.id!)
                                        },
                                        onOpen: {
                                            self.navigationService.navigate(
                                                to: .teamScreen(
                                                    teamId: team.id!,
                                                    teamType: .userCard
                                                )
                                            )
                                        }
                                    )
                                )
                            }
                        }
                        
                        if self.commonViewModel.teamViews.isEmpty {
                            self.pageType = .matchNotFound
                        }
                        else {
                            self.commonViewModel.isTeamsEmpty = false
                            self.pageType = .pageNotFound
                        }
                        break
                    case .failure(let error):
                        self.pageType = .matchNotFound
                        break
                    }
                }
            }
        }
        else {
            self.repository.getAroundMeCards(
                specificity: self.commonViewModel.networkingSpecificities,
                code: self.forumCode ?? ""
            ) {
                [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let cardModels):
                            for card in cardModels {
                                if card.like != true {
                                    self.commonViewModel.cardViews.append(
                                        SwipeCardView(
                                            cardModel: card,
                                            onDislike: {
                                                self.dislike(id: card.id)
                                            },
                                            onLike: {
                                                self.like(id: card.id)
                                            },
                                            onOpen: {
                                                self.navigationService.navigate(
                                                    to: .cardScreen(
                                                        cardId: card.id,
                                                        cardType: .userCard
                                                    )
                                                )
                                            }
                                        )
                                    )
                                }
                        }
                        
                        if self.commonViewModel.cardViews.isEmpty {
                            self.pageType = .matchNotFound
                        }
                        else {
                            self.commonViewModel.isCardsEmpty = false
                            self.pageType = .pageNotFound
                        }
                        break
                    case .failure(let error):
                        self.pageType = .matchNotFound
                        break
                    }
                }
            }
        }
    }
    
    func setSeen(id: String) {
        self.repository.patchAroundme(
            id: id
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    break
                }
            }
        }
    }
    
    func openFilterSheet() {
        self.isFilterSheet = true
        
        self.isTeam = self.commonViewModel.isTeamStorage
    }
    
    func closeFilterSheet() {
        self.isFilterSheet = false
        
        UserDefaults.standard.set(
            self.isTeam,
            forKey: "is_team"
        )
        
        self.getAroundMe()
    }
    
    func openExitNetworkingSheet() {
        self.isExitNetworkingSheet = true
    }
    
    func closeExitNetworkingSheet() {
        UserDefaults.standard.removeObject(forKey: "forum_code")
        
        self.isExitNetworkingSheet = false
        
        self.onInit()
    }
    
    func openForumCodeSheet() {
        self.isForumCodeSheet = true
        self.pinCode = ""
    }
    
    func startAgain() {
        self.commonViewModel.cardViews = []
        self.commonViewModel.teamViews = []
        
        self.repository.postClear(
            isTeam: self.isTeam
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.getAroundMe()
                    break
                case .failure(let error):
                    break
                }
            }
        }
    }
    
    func setForumCode() {
        if (self.pinCode.count == 4) {
            self.isForumCodeSheet = false
            
            self.commonRepository.postMyLocation(
                latitude: 0,
                longitude: 0,
                code: self.pinCode
            ) {
                [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let locationModel):
                        UserDefaults.standard.set(
                            self.pinCode,
                            forKey: "forum_code"
                        )
                        
                        if locationModel.name != nil {
                            self.commonViewModel.forumName = locationModel.name!
                        }
                        
                        self.getAroundMe()
                        
                        break
                    case .failure(let error):
                        // Handle error
                        break
                    }
                }
            }
        }
    }
    
    func openFilters() {
        self.isFilterSheet = false
        
        self.navigationService.navigate(
            to: .filterScreen(
                isFavorites: false
            )
        )
    }
    
    func changeTeamSeek(isTeam: Bool) {
        self.isTeam = isTeam
    }
    
    func like(id: String) {
        if self.commonViewModel.cards.isEmpty {
            self.noCardsSheet = true
            return
        }
        
        if self.commonViewModel.isTeamStorage {
            if self.commonViewModel.teamMainModel == nil {
                self.commonRepository.postRequest(
                    id: id
                ) {
                    [self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_):
                            self.commonViewModel.showAlert()
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
                
                self.currentTeamId = id
            }
        }
        else {
            if self.commonViewModel.teamMainModel == nil {
                self.commonRepository.postFavorites(
                    cardId: id
                ) {
                    [self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_):
                            self.commonViewModel.cardViews.removeLast()
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
                        cardId: id
                    ) {
                        [self] result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(_):
                                self.commonViewModel.cardViews.removeLast()
                                break
                            case .failure(let error):
                                break
                            }
                        }
                    }
                }
                else {
                    self.commonRepository.postTeamInvite(
                        id: id
                    ) {
                        [self] result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(_):
                                self.commonViewModel.cardViews.removeLast()
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
                    self.like(id: self.currentTeamId)
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
                    self.like(id: self.currentTeamId)
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
        self.commonRepository.deleteFavorites(
            cardId: id
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    self.commonViewModel.teamViews.removeLast()
                    break
                }
            }
        }
    }
    
    func createCard() {
        self.noCardsSheet = false
        self.navigationService.navigate(
            to: .cardScreen(
                cardId: "",
                cardType: .newCard
            )
        )
    }
    
    func setIsSteam(isTeam: Bool) {
        UserDefaults.standard.set(
            isTeam,
            forKey: "is_team"
        )
        
        self.isChooseStatusSheet = false
        
        self.getAroundMe()
    }
}
