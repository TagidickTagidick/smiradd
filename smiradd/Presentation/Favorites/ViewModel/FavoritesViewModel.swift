import SwiftUI
import CodeScanner

class FavoritesViewModel: ObservableObject {
    @Published var isShowingScanner: Bool = false
    
    @Published var isAlert: Bool = false
    private var cardId: String = ""
    
    private let repository: IFavoritesRepository
    private let navigationService: NavigationService
    private let commonRepository: ICommonRepository
    private let commonViewModel: CommonViewModel
    
    init(
        repository: IFavoritesRepository,
        navigationService: NavigationService,
        commonRepository: ICommonRepository,
        commonViewModel: CommonViewModel
    ) {
        self.repository = repository
        self.navigationService = navigationService
        self.commonRepository = commonRepository
        self.commonViewModel = commonViewModel
        self.getFavorites(isRefresh: false)
    }
    
    func getFavorites(isRefresh: Bool = true) {
        self.commonViewModel.favoritesPageType = .loading
        
        let startTime = Date()
        
        self.repository.getFavorites() {
            [self] result in
            Task {
                let endTime = Date()
                
                let duration = endTime.timeIntervalSince(startTime)
                
                if duration < 1.0 && isRefresh {
                    try? await Task.sleep(
                        nanoseconds: UInt64(1000000000 - duration * 1000000000)
                    )
                }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let favoritesModel):
                        self.commonViewModel.favoritesModel = favoritesModel
                        
                        if self.commonViewModel.favoritesModel!.items.isEmpty {
                            self.commonViewModel.favoritesPageType = .nothingHereFavorites
                        }
                        else {
                            self.commonViewModel.favoritesPageType = .matchNotFound
                        }
                        break
                    case .failure(let error):
                        if error.message == "Превышен лимит времени на запрос."
                            || error.message == "Вероятно, соединение с интернетом прервано." {
                            self.commonViewModel.favoritesPageType = .noResultsFound
                        }
                        else {
                            self.commonViewModel.favoritesPageType = .somethingWentWrong
                        }
                        break
                    }
                }
            }
        }
    }
    
    func openScanner() {
        self.isShowingScanner = true
    }
    
    func navigateToFilters() {
        self.navigationService.navigate(
            to: .filterScreen(
                isFavorites: true
            )
        )
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        self.isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")[0]
            self.navigationService.navigate(
                to: .cardScreen(
                    cardId: String(details.split(separator: "/").last!),
                    cardType: .userCard
                )
            )
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func openFilters() {
        self.navigationService.navigate(
            to: .filterScreen(
                isFavorites: true
            )
        )
    }
    
    func navigateToCard(id: String) {
        self.navigationService.navigate(
            to: .cardScreen(
                cardId: id,
                cardType: .userCard
            )
        )
    }
    
    func openAlert(id: String) {
        self.cardId = id
        self.isAlert = true
    }
    
    func dislike() {
        self.isAlert = false
        
        self.commonRepository.deleteFavorites(
            cardId: self.cardId
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.commonViewModel.favoritesModel!.items.removeAll(
                        where: { $0.id == self.cardId }
                    )
                    if self.commonViewModel.favoritesModel!.items.isEmpty {
                        self.commonViewModel.favoritesPageType = .nothingHereFavorites
                    }
                    break
                case .failure(let error):
                    break
                }
            }
        }
    }
}
