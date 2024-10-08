import SwiftUI

class FilterViewModel: ObservableObject {
    @Published var isFavorites: Bool = false
    @Published var pageType: PageType = .loading
    
    @Published var currentSpecificities: [SpecificityModel] = []
    @Published var networkingSpecificities: [String] = []
    @Published var favoritesSpecificities: [String] = []
    
    @Published var find: String = ""
    
    private let commonRepository: ICommonRepository
    private let navigationService: NavigationService
    private let commonViewModel: CommonViewModel
    
    init(
        commonRepository: ICommonRepository,
        navigationService: NavigationService,
        commonViewModel: CommonViewModel,
        currentSpecificities: [String],
        isFavorites: Bool
    ) {
        self.commonRepository = commonRepository
        self.navigationService = navigationService
        self.commonViewModel = commonViewModel
        self.isFavorites = isFavorites
        self.getSpecificities(currentSpecificities: currentSpecificities)
    }
    
    private func getSpecificities(
        currentSpecificities: [String]
    ) {
        if self.commonViewModel.specificities.isEmpty {
            self.commonRepository.getSpecificities() {
                [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let specificityModels):
                        self.currentSpecificities = specificityModels
                        self.commonViewModel.specificities = specificityModels
                        if self.isFavorites {
                            self.favoritesSpecificities = currentSpecificities
                        }
                        else {
                            self.networkingSpecificities = currentSpecificities
                        }
                        self.pageType = .matchNotFound
                        break
                    case .failure(let error):
                        break
                    }
                }
            }
        }
        else {
            self.currentSpecificities = self.commonViewModel.specificities
            if self.isFavorites {
                self.favoritesSpecificities = currentSpecificities
            }
            else {
                self.networkingSpecificities = currentSpecificities
            }
            self.pageType = .matchNotFound
        }
    }
    
    func onClearFind() {
        if self.find.isEmpty {
            return
        }
        
        self.find = ""
    }
    
    func onChangeFind() {
        if self.find.isEmpty {
            self.currentSpecificities = self.commonViewModel.specificities
        }
        else {
            self.currentSpecificities = []
            for specificity in self.commonViewModel.specificities {
                if specificity.name.contains(find) {
                    self.currentSpecificities.append(specificity)
                }
            }
        }
    }
    
    func onTapSpecificity(
        name: String
    ) {
        if self.isFavorites {
            if self.favoritesSpecificities.contains(name) {
                for i in 0 ..< self.favoritesSpecificities.count {
                    if self.favoritesSpecificities[i] == name {
                        self.favoritesSpecificities.remove(at: i)
                        break
                    }
                }
            }
            else {
                self.favoritesSpecificities.append(name)
            }
        }
        else {
            if self.networkingSpecificities.contains(name) {
                for i in 0 ..< self.networkingSpecificities.count {
                    if self.networkingSpecificities[i] == name {
                        self.networkingSpecificities.remove(at: i)
                        break
                    }
                }
            }
            else {
                self.networkingSpecificities.append(name)
            }
        }
    }
    
    func navigateBack() {
        self.navigationService.navigateBack()
    }
}
