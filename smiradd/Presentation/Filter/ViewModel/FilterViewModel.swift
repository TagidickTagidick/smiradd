import SwiftUI

class FilterViewModel: ObservableObject {
    private let repository: IProfileRepository
    private let commonRepository: ICommonRepository
    private let navigationService: NavigationService
    
    init(
        repository: IProfileRepository,
        commonRepository: ICommonRepository,
        navigationService: NavigationService
    ) {
        self.repository = repository
        self.commonRepository = commonRepository
        self.navigationService = navigationService
        self.getProfile()
    }
}
