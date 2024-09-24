import SwiftUI
import CodeScanner

class FavoritesViewModel: ObservableObject {
    @Published var pageType: PageType = .loading
    
    @Published var isShowingScanner: Bool = false
    
    @Published var favoritesModel: FavoritesModel?
    
    @Published var isAlert: Bool = false
    
    private let repository: IFavoritesRepository
    private let navigationService: NavigationService
    private let commonRepository: ICommonRepository
    
    init(
        repository: IFavoritesRepository,
        navigationService: NavigationService,
        commonRepository: ICommonRepository
    ) {
        self.repository = repository
        self.navigationService = navigationService
        self.commonRepository = commonRepository
    }
    
    func getFavorites() {
        self.repository.getFavorites() {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let favoritesModel):
                    self.favoritesModel = favoritesModel
                    
                    if self.favoritesModel!.items.isEmpty {
                        self.pageType = .nothingHereFavorites
                    }
                    else {
                        self.pageType = .matchNotFound
                    }
                    break
                case .failure(let error):
                    break
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
            let details = result.string.components(separatedBy: "\n")
            UIApplication
                .shared
                .open(URL(string: details[0])!)
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
                cardType: .favoriteCard
            )
        )
    }
    
    func openAlert() {
        self.isAlert = true
    }
    
    func dislike(id: String) {
        self.isAlert = false
        
        self.commonRepository.deleteFavorites(
            cardId: id
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.favoritesModel!.items.removeAll(
                        where: { $0.id == id }
                    )
                    break
                case .failure(let error):
                    break
                }
            }
        }
    }
}
