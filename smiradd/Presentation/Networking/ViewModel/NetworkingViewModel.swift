import SwiftUI
import CardStack

class NetworkingViewModel: ObservableObject {
    @Published var cards = CardStackModel<_, LeftRight>(CardModel.mock)
    
    @Published var pageType: PageType = .loading
    
    @Published var isSheet: Bool = false
    
    @Published var pinCode: String = ""
    
    @Published var isExitNetworkingSheet: Bool = false
    
    private let repository: INetworkingRepository
    private let navigationService: NavigationService
    
    init(
        repository: INetworkingRepository,
        navigationService: NavigationService
    ) {
        self.repository = repository
        self.navigationService = navigationService
    }
    
    func onInit() {
        self.repository.getAroundMe() { [self] result in
            DispatchQueue.main.async {
                self.pageType = .loading
                switch result {
                case .success(let responseCards):
                    for card in responseCards {
                        if card.like != true {
                            self.cards.appendElement(card)
                        }
                    }
                    break
                case .failure(let error):
                    self.pageType = .nothingHereProfile
                    break
                }
            }
        }
    }
    
    func openExitNetworkingSheet() {
        self.isExitNetworkingSheet = true
    }
    
    func closeExitNetworkingSheet() {
        self.isExitNetworkingSheet = false
    }
}
