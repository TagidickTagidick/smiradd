import SwiftUI
import CoreLocation
import CardStack

class CommonViewModel: ObservableObject {
    @Published var networkingPageType: PageType = .loading
    
    @Published var location: CLLocationCoordinate2D?
    
    @Published var networkingCards = CardStackModel<_, LeftRight>(CardModel.mocks)
    @Published var networkingTeams = CardStackModel<_, LeftRight>(TeamModel.mocks)
    
    @Published var specificities: [SpecificityModel] = []
    @Published var networkingSpecificities: [String] = []
    @Published var favoritesSpecificities: [String] = []
    
    @Published var templates: [TemplateModel] = []
    
    @Published var myCards: [CardModel] = []
    @Published var myTeamMainModel: TeamMainModel?
    
    @Published var isCardsEmpty: Bool = true
    
    @Published var isTeamsEmpty: Bool = true
    
    @Published var locationModel: LocationModel?
    
    @Published var isAlert: Bool = false
    
    @Published var profileModel: ProfileModel?
    
    @Published var notificationsModel: NotificationsModel?
    
    @Published var isExitTeam: Bool = false
    @Published var isDeleteTeam: Bool = false
    @Published var noCardsSheet: Bool = false
    @Published var currentTeamId: String = ""
    
    @Published var cardModel: CardModel = CardModel.mock
    @Published var teamMainModel: TeamMainModel = TeamMainModel.mock
    
    @Published var achievements: [AchievementModel] = []
    @Published var services: [ServiceModel] = []
    
    var cardsCount: Int = 0
    var teamsCount: Int = 0
    
    var timeRemaining = 5
    var timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    )
    
    var isTeamStorage: Bool {
        return UserDefaults.standard.bool(forKey: "is_team")
    }
    
    var forumCode: String? {
        return UserDefaults.standard.string(forKey: "forum_code")
    }
    
    private let repository: ICommonRepository
    
    init(
        repository: ICommonRepository
    ) {
        self.repository = repository
    }
    
    func removeAll() {
        UserDefaults.standard.removeObject(
            forKey: "forum_code"
        )
        UserDefaults.standard.removeObject(
            forKey: "is_team"
        )
        UserDefaults.standard.removeObject(
            forKey: "access_token"
        )
        UserDefaults.standard.removeObject(
            forKey: "refresh_token"
        )
        
        self.networkingSpecificities = []
        self.favoritesSpecificities = []
        self.templates = []
        self.myCards = []
        self.myTeamMainModel = nil
        self.locationModel = nil
    }
    
    func changeSpecificities(
        newSpecificities: [String],
        isFavorite: Bool
    ) {
        if isFavorite {
            self.favoritesSpecificities = newSpecificities
        }
        else {
            self.networkingSpecificities = newSpecificities
        }
    }
    
    func showAlert() {
        withAnimation {
            self.isAlert = true
        }
        
        self.timeRemaining = 5
        
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
        self.timer.connect()
    }
    
    func checkCanGetAroundMe() {
        if self.isTeamStorage {
            self.teamsCount -= 1
            
            if self.teamsCount == 3 {
                self.getAroundMe()
            }
        }
        else {
            self.cardsCount -= 1
            
            if self.cardsCount == 3 {
                self.getAroundMe()
            }
        }
    }
    
    func getAroundMe() {
        self.networkingPageType = .loading
        
        self.networkingCards.removeAllElements()
        self.networkingTeams.removeAllElements()
        
        self.cardsCount = 0
        self.teamsCount = 0
        
        if self.isTeamStorage {
            self.repository.getAroundMeTeams(
                specificity: self.networkingSpecificities,
                code: self.forumCode ?? ""
            ) {
                [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let teamModels):
                        for team in teamModels {
                            if self.myTeamMainModel?.team.id != team.id {
                                self.networkingTeams.appendElement(team)
                                
                                self.teamsCount += 1
                            }
                        }
                        
                        if self.networkingTeams.numberOfElements <= 3 {
                            self.networkingPageType = .pageNotFound
                        }
//                        else {
//                            self.commonViewModel.isTeamsEmpty = false
//                            self.pageType = .pageNotFound
//                        }
                        break
                    case .failure(let error):
                        self.networkingPageType = .pageNotFound
                        break
                    }
                }
            }
        }
        else {
            self.repository.getAroundMeCards(
                specificity: self.networkingSpecificities,
                code: self.forumCode ?? ""
            ) {
                [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let cardModels):
                            for card in cardModels {
                                if card.like != true {
                                    self.networkingCards.appendElement(card)
                                    self.cardsCount += 1
                                }
                        }
                        
                        if self.networkingCards.numberOfElements <= 3 {
                            self.networkingPageType = .pageNotFound
                        }
//                        else {
//                            self.commonViewModel.isCardsEmpty = false
//                            self.pageType = .pageNotFound
//                        }
                        break
                    case .failure(let error):
                        self.networkingPageType = .matchNotFound
                        break
                    }
                }
            }
        }
    }
    
    func dislike(id: String) {
        self.repository.patchAroundme(
            id: id
        ) {
            [self] result in
            self.checkCanGetAroundMe()
        }
    }
    
    func like(id: String) {
        if self.myCards.isEmpty {
            self.noCardsSheet = true
            return
        }
        
        if self.isTeamStorage {
            if self.myTeamMainModel == nil {
                self.repository.postRequest(
                    id: id
                ) {
                    [self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_):
                            self.showAlert()
                            
                            self.checkCanGetAroundMe()
                            break
                        case .failure(_):
                            break
                        }
                    }
                }
            }
            else {
                if self.myCards.first(
                    where: {
                        $0.id == self.myTeamMainModel!.owner_card_id!
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
            if self.myTeamMainModel == nil {
                self.repository.postFavorites(
                    cardId: id
                ) {
                    _ in
                    self.checkCanGetAroundMe()
                }
            }
            else {
                if self.myCards.first(
                    where: {
                        $0.id == self.myTeamMainModel!.owner_card_id!
                    }
                ) == nil {
                    self.repository.postFavorites(
                        cardId: id
                    ) {
                        _ in
                        self.checkCanGetAroundMe()
                    }
                }
                else {
                    self.repository.postTeamInvite(
                        id: id
                    ) {
                        _ in
                        self.checkCanGetAroundMe()
                    }
                }
            }
        }
    }
    
    func leaveAndLike() {
        self.repository.deleteLeaveTeam() {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.myTeamMainModel = nil
                    self.like(id: self.currentTeamId)
                    break
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func deleteAndLike() {
        self.repository.deleteTeam() {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.myTeamMainModel = nil
                    self.like(id: self.currentTeamId)
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
                
                self.networkingPageType = .matchNotFound
            }
        }
    }
    
    func saveService(
        index: Int,
        coverUrl: String,
        coverImage: UIImage?,
        coverVideo: URL?,
        name: String,
        description: String,
        price: String
    ) {
        if name.isEmpty || description.isEmpty {
            return
        }
        
        if index == -1 {
            self.services.append(
                ServiceModel(
                    name: name,
                    description: description,
                    price: Int(price) ?? 0,
                    cover_url: coverUrl,
                    coverImage: coverImage,
                    coverVideo: coverVideo
                )
            )
        }
        else {
            self.services[index] = ServiceModel(
                name: name,
                description: description,
                price: Int(price) ?? 0,
                cover_url: coverUrl,
                coverImage: coverImage,
                coverVideo: coverVideo
            )
        }
    }
    
    func deleteService(index: Int) {
        self.services.remove(at: index)
    }
    
    func saveAchievement(
        index: Int,
        name: String,
        description: String,
        url: String
    ) {
        if name.isEmpty {
            return
        }
        
        if index == -1 {
            self.achievements.append(
                AchievementModel(
                    name: name,
                    description: description,
                    url: url
                )
            )
        }
        else {
            self.achievements[index] = AchievementModel(
                name: name,
                description: description,
                url: url
            )
        }
    }
    
    func deleteAchievement(index: Int) {
        self.achievements.remove(at: index)
    }
    
    func startAgain() {
        self.networkingCards.removeAllElements()
        self.networkingTeams.removeAllElements()
        
        self.cardsCount = 0
        self.teamsCount = 0
        
        self.repository.postClear(
            isTeam: self.isTeamStorage
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
}
