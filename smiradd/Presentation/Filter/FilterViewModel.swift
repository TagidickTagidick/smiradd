import SwiftUI

class FilterViewModel: ObservableObject {
    @Published var isFavorites: Bool = false
    @Published var pageType: PageType = .loading
    
    @Published var specificityList: [SpecificityModel] = []
    @Published var currentSpecifities: [SpecificityModel] = []
    @Published var networkingSpecificities: [String] = []
    @Published var favoritesSpecificities: [String] = []
    
    @Published var find: String = ""
    
    private let commonRepository: ICommonRepository
    private let navigationService: NavigationService
    
    init(
        commonRepository: ICommonRepository,
        navigationService: NavigationService,
        commonSpecifities: [String],
        isFavorites: Bool
    ) {
        self.commonRepository = commonRepository
        self.navigationService = navigationService
        self.isFavorites = isFavorites
        self.getSpecificities(commonSpecifities: commonSpecifities)
    }
    
    private func getSpecificities(
        commonSpecifities: [String]
    ) {
        self.commonRepository.getSpecificities() {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let specificityModels):
                    self.currentSpecifities = specificityModels
                    self.specificityList = specificityModels
                    if self.isFavorites {
                        self.favoritesSpecificities = commonSpecifities
                    }
                    else {
                        self.networkingSpecificities = commonSpecifities
                    }
                    self.pageType = .matchNotFound
                    break
                case .failure(let error):
                    break
                }
            }
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
            self.currentSpecifities = self.specificityList
        }
        else {
            self.currentSpecifities = []
            for specificity in self.specificityList {
                if specificity.name.contains(find) {
                    self.currentSpecifities.append(specificity)
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
