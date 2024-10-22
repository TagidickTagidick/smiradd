import SwiftUI
import CoreLocation
import Combine

class SplashScreenViewModel: ObservableObject {
    private let commonRepository: ICommonRepository
    
    private let commonViewModel: CommonViewModel
    
    private let navigationService: NavigationService
    
    private let locationManager: LocationManager
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        commonRepository: ICommonRepository,
        commonViewModel: CommonViewModel,
        navigationService: NavigationService,
        locationManager: LocationManager
    ) {
        self.commonRepository = commonRepository
        self.commonViewModel = commonViewModel
        self.navigationService = navigationService
        self.locationManager = locationManager
        self.locationManager.checkLocationAuthorization()
    }
    
//    private func getCards() {
//        self.commonRepository.getCards() {
//            [self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let cardModels):
//                    self.commonViewModel.cards = cardModels
//                    self.getTeam()
//                case .failure(let error):
//                    print(error)
//                    break
//                }
//            }
//        }
//    }
//    
//    private func getTeam() {
//        self.commonRepository.getTeam {
//            [self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let teamMainModel):
//                    self.commonViewModel.myTeamMainModel = teamMainModel
//                case .failure(let error):
//                    break
//                }
//                self.getTemplates()
//            }
//        }
//    }
//    
//    private func getTemplates() {
//        self.commonRepository.getTemplates() {
//            [self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let templateModels):
//                    self.commonViewModel.templates = templateModels
//                    self.locationManager.checkLocationAuthorization()
//                    break
//                case .failure(let error):
//                    // Handle error
//                    break
//                }
//            }
//        }
//    }
}
