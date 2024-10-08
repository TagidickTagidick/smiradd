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
        self.setUpLocationSubscription()
        self.setUpAuthorizationSubscription()
        switch self.locationManager.checkAuthorization() {
                            case .notDetermined:
                                self.locationManager.requestLocationWhenInUseAuthorization()
                            case .restricted, .denied:
            self.getCards()
                            case .authorizedWhenInUse, .authorizedAlways:
                                self.locationManager.requestLocation()
                            @unknown default:
                                break
                            }
    }
    
    private func setUpLocationSubscription() {
        self.locationManager.$location
            .compactMap { $0 }
            .sink {
                [weak self] location in
                print(location)
                self?.setLocation(location)
            }
            .store(in: &cancellables)
    }
    
    private func setUpAuthorizationSubscription() {
        self.locationManager.$authorizationStatus
            .sink {
                [weak self] status in
                self?.handleAuthorizationStatus(status)
            }
            .store(in: &cancellables)
    }
    
    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        print("рфврырфвы \(status)")
        switch status {
            case .notDetermined:
                self.locationManager.requestLocationWhenInUseAuthorization()
            case .restricted, .denied:
                self.getCards()
            case .authorizedWhenInUse, .authorizedAlways:
                self.locationManager.requestLocation()
            @unknown default:
                break
            }
        }
    
    private func setLocation(_ location: CLLocationCoordinate2D) {
        self.commonRepository.postMyLocation(
            latitude: location.latitude,
            longitude: location.longitude,
            code: ""
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let locationModel):
                    if locationModel.name != nil {
                        self.commonViewModel.forumName = locationModel.name!
                    }
                    if locationModel.type != nil {
                        self.commonViewModel.isTeamForum = locationModel.type == "TeamForum"
                    }
                    self.getCards()
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
            }
        }
    }
    
    private func getCards() {
        self.commonRepository.getCards() {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cardModels):
                    self.commonViewModel.cards = cardModels
                    self.getTeam()
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    }
    
    private func getTeam() {
        self.commonRepository.getTeam {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let teamMainModel):
                    self.commonViewModel.teamMainModel = teamMainModel
                case .failure(let error):
                    break
                }
                self.getTemplates()
            }
        }
    }
    
    private func getTemplates() {
        self.commonRepository.getTemplates() {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let templateModels):
                    self.commonViewModel.templates = templateModels
                    self.navigationService.navigate(
                        to: .networkingScreen
                    )
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
            }
        }
    }
}
