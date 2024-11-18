import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    var manager = CLLocationManager()
    var authorizationStatus = CLAuthorizationStatus.notDetermined
    
    private let navigationService: NavigationService
    private let commonViewModel: CommonViewModel
    private let commonRepository: CommonRepository
    
    init(
        navigationService: NavigationService,
        commonViewModel: CommonViewModel,
        commonRepository: CommonRepository
    ) {
        self.navigationService = navigationService
        self.commonViewModel = commonViewModel
        self.commonRepository = commonRepository
    }
    
    func checkLocationAuthorization() {
        
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
        
        self.authorizationStatus = self.manager.authorizationStatus
        
        switch self.manager.authorizationStatus {
        case .notDetermined://The user choose allow or denny your app to get the location yet
            self.manager.requestWhenInUseAuthorization()
            break
        case .restricted://The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.
            print("Location restricted")
            
        case .denied://The user dennied your app to get location or disabled the services location or the phone is in airplane mode
            print("Location denied")
            
        case .authorizedAlways://This authorization allows you to use all location services and receive location events whether or not your app is in use.
            print("Location authorizedAlways")
        case .authorizedWhenInUse://This authorization allows you to use all location services and receive location events only when your app is in use
            print("Location authorized when in use")
            self.commonViewModel.location = manager.location?.coordinate
            self.passLocation()
            break
        @unknown default:
            print("Location service disabled")
        
        }
    }
    
    func passLocation() {
        if UserDefaults.standard.string(forKey: "forum_code") == nil {
            self.commonRepository.postMyLocation(
                latitude: commonViewModel.location?.latitude ?? 0,
                longitude: commonViewModel.location?.longitude ?? 0,
                code: ""
            ) {
                result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let locationModel):
                        
                        self.commonViewModel.locationModel = locationModel
                        
                        UserDefaults.standard.set(
                            self.commonViewModel.locationModel?.type == "TeamForum",
                            forKey: "is_team"
                        )
                        
                        self.getCards()
                        
                        break
                    case .failure(let error):
                        // Handle error
                        break
                    }
                }
            }
        }
        else {
            self.getCards()
        }
    }
    
    private func getCards() {
        self.commonRepository.getCards() {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cardModels):
                    self.commonViewModel.myCards = cardModels
                    
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
                    self.commonViewModel.myTeamMainModel = teamMainModel
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
    
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        if self.authorizationStatus != .authorizedWhenInUse && self.authorizationStatus != .authorizedAlways {
            self.checkLocationAuthorization()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        self.commonViewModel.location = locations.first?.coordinate
    }
}
