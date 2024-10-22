import SwiftUI
import CardStack

class NetworkingViewModel: ObservableObject {
    @Published var isForumCodeSheet: Bool = false
    @Published var isFilterSheet: Bool = false
    
    @Published var pinCode: String = ""
    
    @Published var isQuestionForumSheet: Bool = false
    @Published var isChooseStatusSheet: Bool = false
    @Published var isExitNetworkingSheet: Bool = false
    
    @Published var isTeam: Bool = false
    
    private let navigationService: NavigationService
    private let locationManager: LocationManager
    private let commonViewModel: CommonViewModel
    private let commonRepository: CommonRepository
    
    init(
        navigationService: NavigationService,
        locationManager: LocationManager,
        commonViewModel: CommonViewModel,
        commonRepository: CommonRepository
    ) {
        self.navigationService = navigationService
        self.locationManager = locationManager
        self.commonViewModel = commonViewModel
        self.commonRepository = commonRepository
        self.commonViewModel.networkingCards.removeAllElements()
        self.commonViewModel.networkingTeams.removeAllElements()
        self.isTeam = self.commonViewModel.isTeamStorage
        self.onInit()
    }
    
    func onInit() {
        self.commonViewModel.networkingCards.removeAllElements()
        self.commonViewModel.networkingTeams.removeAllElements()
        
        if self.commonViewModel.location == nil {
            self.commonViewModel.networkingPageType = .shareLocation
            return
        }
        
        self.commonViewModel.networkingPageType = .matchNotFound
        
        self.commonViewModel.getAroundMe()
        
//        if !self.commonViewModel.forumName.isEmpty && !UserDefaults.standard.bool(forKey: "first_time_forum") {
//            UserDefaults.standard.set(
//                true,
//                forKey: "first_time_forum"
//            )
//            
//            self.isQuestionForumSheet = true
//            
//            return
//        }
//        
//        if !UserDefaults.standard.bool(forKey: "first_time_forum") {
//            UserDefaults.standard.set(
//                true,
//                forKey: "first_time_forum"
//            )
//        }
//        
//        self.commonViewModel.getAroundMe()
    }
    
    func openForumCodeSheet() {
        self.isForumCodeSheet = true
        self.pinCode = ""
    }
    
    func setForumCode() {
        if self.pinCode.count != 4 {
            return
        }
        
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
                    self.commonViewModel.locationModel = locationModel
                    
                    self.isQuestionForumSheet = true
                    
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
            }
        }
    }
    
    func answerNoQuestionForumSheet() {
        self.isQuestionForumSheet = false
    }
    
    func answerYesQuestionForumSheet() {
        self.isQuestionForumSheet = false
        
        print("пфвпвфпф \(self.pinCode)")
        
        UserDefaults.standard.set(
            self.pinCode,
            forKey: "forum_code"
        )
        
        if self.commonViewModel.locationModel?.type == "TeamForum" {
            self.isChooseStatusSheet = true
        }
        else {
            UserDefaults.standard.set(
                false,
                forKey: "is_team"
            )
            
            self.commonViewModel.getAroundMe()
        }
    }
    
    func setIsTeam(isTeam: Bool) {
        UserDefaults.standard.set(
            isTeam,
            forKey: "is_team"
        )
        
        self.isChooseStatusSheet = false
        
        self.commonViewModel.getAroundMe()
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
        
        self.commonViewModel.getAroundMe()
    }
    
    func openExitNetworkingSheet() {
        self.isExitNetworkingSheet = true
    }
    
    func closeExitNetworkingSheet() {
        self.isExitNetworkingSheet = false
        
        UserDefaults.standard.removeObject(
            forKey: "forum_code"
        )
        
        self.commonViewModel.networkingCards.removeAllElements()
        self.commonViewModel.networkingTeams.removeAllElements()
        
        self.commonViewModel.networkingPageType = .matchNotFound
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
    
    func createCard() {
        self.commonViewModel.noCardsSheet = false
        self.navigationService.navigate(
            to: .cardScreen(
                cardId: "",
                cardType: .newCard
            )
        )
    }
    
    func openCard(id: String) {
        self.navigationService.navigate(
            to: .cardScreen(
                cardId: id,
                cardType: .userCard
            )
        )
    }
    
    func openTeam(id: String) {
        self.navigationService.navigate(
            to: .teamScreen(
                teamId: id,
                teamType: .userCard
            )
        )
    }
}
