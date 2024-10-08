import SwiftUI

class CommonViewModel: ObservableObject {
    @Published var cardViews: [SwipeCardView] = []
    
    @Published var teamViews: [SwipeTeamView] = []
    
    @Published var specificities: [SpecificityModel] = []
    @Published var networkingSpecificities: [String] = []
    @Published var favoritesSpecificities: [String] = []
    
    @Published var templates: [TemplateModel] = []
    
    @Published var cards: [CardModel] = []
    
    @Published var isCardsEmpty: Bool = true
    
    @Published var isTeamsEmpty: Bool = true
    
    @Published var teamMainModel: TeamMainModel?
    
    @Published var forumName: String = ""
    @Published var isTeamForum: Bool = false
    
    @Published var isAlert: Bool = false
    
    @Published var isQRCode: Bool = false
    
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
    
    private let repository: ICommonRepository
    
    init(
        repository: ICommonRepository
    ) {
        self.repository = repository
    }
    
    func removeAll() {
        self.networkingSpecificities = []
        self.favoritesSpecificities = []
        self.templates = []
        self.cards = []
        self.teamMainModel = nil
        self.forumName = ""
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
    
    func openQRCode() {
        self.isQRCode = true
    }
    
    func closeQRCode() {
        self.isQRCode = false
    }
}
