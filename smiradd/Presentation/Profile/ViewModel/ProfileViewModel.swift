import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var pageType: PageType = .loading
    
    @Published var cards: [CardModel] = []
    
    @Published var profileModel: ProfileModel?
    
    @Published var notificationsModel: NotificationsModel?
    
    @Published var templates: [TemplateModel] = []
    
    private let repository: IProfileRepository
    private let navigationService: NavigationService
    
    init(
        repository: IProfileRepository,
        navigationService: NavigationService
    ) {
        self.repository = repository
        self.navigationService = navigationService
    }
    
    func onAppear() {
        self.pageType = .loading
        
        self.repository.getProfile {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileModel):
                    self.profileModel = profileModel
                    self.repository.getCards {
                        [self] result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let cardModels):
                                self.cards = cardModels
                                self.repository.getNotifications {
                                    [self] result in
                                    DispatchQueue.main.async {
                                        switch result {
                                        case .success(let notificationModel):
                                            self.notificationsModel = notificationModel
                                            break
                                        case .failure(let error):
                                            // Handle error
                                            break
                                        }
                                        self.pageType = .matchNotFound
                                    }
                                }
                                break
                            case .failure(let error):
                                // Handle error
                                break
                            }
                        }
                    }
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
            }
        }
    }
}
