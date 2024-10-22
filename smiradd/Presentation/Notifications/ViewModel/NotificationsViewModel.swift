import SwiftUI
import Foundation

class NotificationsViewModel: ObservableObject {
    @Published var pageType: PageType = .matchNotFound
    
    private let repository: INotificationsRepository
    private let commonRepository: ICommonRepository
    private var commonViewModel: CommonViewModel
    private let navigationService: NavigationService
    
    init(
        repository: INotificationsRepository,
        navigationService: NavigationService,
        commonViewModel: CommonViewModel,
        commonRepository: CommonRepository
    ) {
        self.repository = repository
        self.navigationService = navigationService
        self.commonViewModel = commonViewModel
        self.commonRepository = commonRepository
        self.readNotifications()
    }
    
    private func readNotifications() {
        for i in 0 ..< self.commonViewModel.notificationsModel!.items.count {
            if self.commonViewModel.notificationsModel!.items[i].status != "READED" {
                self.repository.patchNotification(
                    id: self.commonViewModel.notificationsModel!.items[i].id,
                    accepted: self.commonViewModel.notificationsModel!.items[i].accepted
                ) {_ in }
            }
            
            self.commonViewModel.notificationsModel!.items[i].status = "READED"
        }
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
                    self.commonViewModel.notificationsModel!.items[
                        self.commonViewModel.notificationsModel!.items.firstIndex(
                        where: {
                            notification in
                            notification.id == id
                        }
                    )!
                    ].accepted = accepted
                    
                    if accepted {
                        var cardModel = CardModel.mock
                        cardModel.avatar_url = self.commonViewModel.notificationsModel!.items.first(
                            where: {
                                notification in
                                notification.id == id
                            }
                        )?.data.avatar_url
                        if self.commonViewModel.myTeamMainModel != nil {
                            self.commonViewModel.myTeamMainModel!.teammates.append(CardModel.mock)
                        }
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func getNotifications() {
        self.pageType = .loading
        
        let startTime = Date()
        
        self.commonRepository.getNotifications {
            [self] result in
            Task {
                let endTime = Date()
                
                let duration = endTime.timeIntervalSince(startTime)
                
                if duration < 1.0 {
                    try? await Task.sleep(
                        nanoseconds: UInt64(1000000000 - duration * 1000000000)
                    )
                }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let notificationsModel):
                        self.commonViewModel.notificationsModel = notificationsModel
                        
                        if self.commonViewModel.notificationsModel!.items.isEmpty {
                            self.pageType = .nothingHereNotifications
                        }
                        else {
                            self.pageType = .matchNotFound
                        }
                        break
                    case .failure(let error):
                        if error.message == "Превышен лимит времени на запрос." || error.message == "Вероятно, соединение с интернетом прервано." {
                            self.pageType = .noResultsFound
                        }
                        else {
                            self.pageType = .somethingWentWrong
                        }
                        break
                    }
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
