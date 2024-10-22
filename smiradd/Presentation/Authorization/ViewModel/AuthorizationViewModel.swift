import SwiftUI
import FirebaseAuth
import Firebase
import Combine
import CoreLocation

class AuthorizationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var emailIsError: Bool = false
    @Published var emailErrorText: String = ""
    
    @Published var password: String = ""
    @Published var passwordIsError: Bool = false
    @Published var passwordErrorText: String = ""
    @Published var passwordIsShown: Bool = false
    
    @Published var isLoading: Bool = false
    
    var isSignUp = false
    
    private let repository: IAuthorizationRepository
    private let navigationService: NavigationService
    private let commonRepository: ICommonRepository
    private let commonViewModel: CommonViewModel
    private let locationManager: LocationManager
    private let notificationManager: NotificationManager
    
    init(
        repository: IAuthorizationRepository,
        isSignUp: Bool,
        navigationService: NavigationService,
        locationManager: LocationManager,
        notificationManager: NotificationManager,
        commonViewModel: CommonViewModel,
        commonRepository: ICommonRepository
    ) {
        self.repository = repository
        self.isSignUp = isSignUp
        self.navigationService = navigationService
        self.commonViewModel = commonViewModel
        self.locationManager = locationManager
        self.notificationManager = notificationManager
        self.commonRepository = commonRepository
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$"#
        return NSPredicate(
            format: "SELF MATCHES %@",
            emailRegex
        ).evaluate(with: email)
    }
    
    func changeAuthorization() {
        self.navigationService.navigate(
            to: self.isSignUp
            ? .signInScreen
            : .signUpScreen
        )
    }
    
    func signUp() {
        guard !self.email.isEmpty, !self.password.isEmpty else {
            return
        }
        
        self.isLoading = true
        
        self.repository.signUpWithEmail(
            email: self.email,
            password: self.password
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let authorizationModel):
                    UserDefaults.standard.set(
                        authorizationModel.access_token,
                        forKey: "access_token"
                    )
                    UserDefaults.standard.set(
                        authorizationModel.refresh_token,
                        forKey: "refresh_token"
                    )
                    Task {
                        await self.notificationManager.request()
                        self.locationManager.checkLocationAuthorization()
                    }
                    break
                case .failure(let errorModel):
                    if errorModel.statusCode == 404 {
                        self.emailIsError = true
                        break
                    }
                    
                    if errorModel.statusCode == 400 {
                        print(errorModel.message)
                        if errorModel.message == "User already registered" {
                            self.emailIsError = true
                            self.emailErrorText = "Аккаунт с такой эл. почтой уже существует"
                            break
                        }
                        else {
                            self.passwordIsError = true
                            break
                        }
                    }
                    
                    break
                }
            }
        }
    }
    
    func signIn() {
        guard !self.email.isEmpty, !self.password.isEmpty else {
            return
        }
        
        self.isLoading = true
        
        self.repository.signInWithEmail(
            email: email,
            password: password
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let authorizationModel):
                    UserDefaults.standard.set(
                        authorizationModel.access_token,
                        forKey: "access_token"
                    )
                    UserDefaults.standard.set(
                        authorizationModel.refresh_token,
                        forKey: "refresh_token"
                    )
                    Task {
                        await self.notificationManager.request()
                        self.locationManager.checkLocationAuthorization()
                    }
                    //self.initUserSettings()
                    break
                case .failure(let errorModel):
                    self.isLoading = false
                    if (errorModel.statusCode == 404) {
                        self.emailErrorText = "Не существует аккаунта с такой эл. почтой"
                        self.emailIsError = true
                        break
                    }
                    
                    if (errorModel.statusCode == 400) {
                        self.passwordErrorText = "Неверный пароль"
                        self.passwordIsError = true
                        break
                    }
                    
                    break
                }
            }
        }
    }
    
//    private func setUpLocationSubscription() {
//        self.locationManager.$location
//            .compactMap { $0 }
//            .sink {
//                [weak self] location in
//                print(location)
//                self?.setLocation(location)
//            }
//            .store(in: &cancellables)
//    }
//    
//    private func setUpAuthorizationSubscription() {
//        self.locationManager.$authorizationStatus
//            .sink {
//                [weak self] status in
//                print(status)
//                self?.handleAuthorizationStatus(status)
//            }
//            .store(in: &cancellables)
//    }
//    
//    private func handleAuthorizationStatus(
//        _ status: CLAuthorizationStatus
//    ) {
//        switch status {
//        case .notDetermined:
//            self.locationManager.requestLocationWhenInUseAuthorization()
//        case .restricted, .denied:
//            self.getCards()
//        case .authorizedWhenInUse, .authorizedAlways:
//            self.locationManager.requestLocation()
//        @unknown default:
//            break
//        }
//    }
    
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
                    self.commonViewModel.locationModel = locationModel
                    break
                case .failure(let error):
                    break
                }
                self.getCards()
            }
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
                    self.isLoading = false
                    self.emailIsError = true
                    self.emailErrorText = "Не удалось получить все данные"
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
                    self.isLoading = false
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
    
    func navigateToRecoverPassword() {
        self.navigationService.navigate(
            to: .restrorePasswordScreen
        )
    }
}
