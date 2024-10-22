import SwiftUI
import FirebaseCore
import Firebase
import FirebaseMessaging
import SDWebImage
import SDWebImageSwiftUI

@main
struct smiraddApp: App, KeyboardReadable {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @ObservedObject var navigationService = NavigationService()
    
    @State private var scrollOffset: CGFloat = 0
    
    @StateObject var commonViewModel = CommonViewModel(
        repository: CommonRepository(
        networkService: NetworkService()
    )
    )
    
    @State private var isEnabled: Bool = false
    @State private var isKeyboardVisible: Bool = false
    
    @State private var isTutorial: Bool = !UserDefaults.standard.bool(
        forKey: "first_time"
    )
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    private func handleIncomingURL(_ url: URL) {
        guard url.scheme == "smiradd" else {
            return
        }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL")
            return
        }
        
        guard let action = components.host, action == "vizme.pro" else {
            print("Unknown URL, we can't handle this one!")
            return
        }
        
        guard let recipeName = components.queryItems?.first(where: { $0.name == "id" })?.value else {
            print("Recipe name not found")
            return
        }

        navigationService.navigate(to: .cardScreen(cardId: recipeName, cardType: .userCard))
    }
    
    @StateObject var notificationManager = NotificationManager()
    
    @Namespace var namespace
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationService.navPath) {
                Spacer()
                    .navigationDestination(for: NavigationService.Destination.self) { i in
                        ZStack (alignment: .bottom) {
                            switch i {
                            case .splashScreen:
                                SplashScreenView(
                                    commonViewModel: self.commonViewModel,
                                    navigationService: self.navigationService,
                                    locationManager: LocationManager(
                                        navigationService: self.navigationService,
                                        commonViewModel: self.commonViewModel,
                                        commonRepository: CommonRepository(
                                            networkService: NetworkService()
                                        )
                                    ),
                                    commonRepository: CommonRepository(
                                        networkService: NetworkService()
                                    )
                                )
                            case .signInScreen:
                                AuthorizationPageView(
                                    isSignUp: false,
                                    repository: AuthorizationRepository(
                                        networkService: NetworkService()
                                    ),
                                    navigationService: self.navigationService,
                                    commonViewModel: self.commonViewModel,
                                    locationManager: LocationManager(
                                        navigationService: self.navigationService,
                                        commonViewModel: self.commonViewModel,
                                        commonRepository: CommonRepository(
                                            networkService: NetworkService()
                                        )
                                    ),
                                    notificationManager: self.notificationManager,
                                    commonRepository: CommonRepository(
                                        networkService: NetworkService()
                                    )
                                )
                            case .signUpScreen:
                                AuthorizationPageView(
                                    isSignUp: true,
                                    repository: AuthorizationRepository(
                                        networkService: NetworkService()
                                    ),
                                    navigationService: navigationService,
                                    commonViewModel: self.commonViewModel,
                                    locationManager: LocationManager(
                                        navigationService: self.navigationService,
                                        commonViewModel: self.commonViewModel,
                                        commonRepository: CommonRepository(
                                            networkService: NetworkService()
                                        )
                                    ),
                                    notificationManager: self.notificationManager,
                                    commonRepository: CommonRepository(
                                        networkService: NetworkService()
                                    )
                                )
                            case .networkingScreen:
                                NetworkingPageView(
                                    navigationService: self.navigationService,
                                    locationManager: LocationManager(
                                        navigationService: self.navigationService,
                                        commonViewModel: self.commonViewModel,
                                        commonRepository: CommonRepository(
                                            networkService: NetworkService()
                                        )
                                    ),
                                    commonViewModel: self.commonViewModel,
                                    commonRepository: CommonRepository(
                                        networkService: NetworkService()
                                    )
                                )
                            case .cardScreen(let cardId, let cardType):
//                                if #available(iOS 18.0, *) {
//                                    CardPageView(
//                                        repository: CardRepository(
//                                            networkService: NetworkService()
//                                        ),
//                                        commonRepository: CommonRepository(
//                                            networkService: NetworkService()
//                                        ),
//                                        navigationService: self.navigationService,
//                                        commonViewModel: self.commonViewModel,
//                                        cardId: cardId,
//                                        cardType: cardType
//                                    )
//                                    .navigationTransition(
//                                        .zoom(
//                                            sourceID: cardId,
//                                            in: namespace
//                                        )
//                                    )
//                                } else {
                                    CardPageView(
                                        repository: CardRepository(
                                            networkService: NetworkService()
                                        ),
                                        commonRepository: CommonRepository(
                                            networkService: NetworkService()
                                        ),
                                        navigationService: self.navigationService,
                                        commonViewModel: self.commonViewModel,
                                        cardId: cardId,
                                        cardType: cardType
                                    )
                                //}
                            case .profileScreen:
                                ProfilePageView(
                                    repository: ProfileRepository(
                                        networkService: NetworkService()
                                    ),
                                    commonRepository: CommonRepository(
                                        networkService: NetworkService()
                                    ),
                                    navigationService: self.navigationService,
                                    commonViewModel: self.commonViewModel
                                )
                            case .favoritesScreen:
                                FavoritesPageView(
                                    repository: FavoritesRepository(
                                        networkService: NetworkService()
                                    ),
                                    navigationService: navigationService,
                                    commonRepository: CommonRepository(
                                        networkService: NetworkService()
                                    )
                                )
                            case .filterScreen(let isFavorites):
                                FilterPageView(
                                    commonRepository: CommonRepository(
                                        networkService: NetworkService()
                                    ),
                                    navigationService: self.navigationService,
                                    commonViewModel: self.commonViewModel,
                                    currentSpecificities: isFavorites ? self.commonViewModel.favoritesSpecificities : self.commonViewModel.networkingSpecificities,
                                    isFavorites: isFavorites
                                )
                            case .teamScreen(
                                let teamId,
                                let teamType
                            ):
                                TeamPageView(
                                    repository: TeamRepository(
                                        networkService: NetworkService()
                                ),
                                    commonRepository: CommonRepository(
                                        networkService: NetworkService()
                                    ),
                                    navigationService: self.navigationService,
                                    teamId: teamId,
                                    teamType: teamType,
                                    commonViewModel: self.commonViewModel
                                )
                            case .restrorePasswordScreen:
                                RestorePasswordPageView(
                                    repository: RestorePasswordRepository(
                                        networkService: NetworkService()
                                    ),
                                    navigationService: self.navigationService
                                )
                            case .notificationsScreen:
                                NotificationsPageView(
                                    repository: NotificationsRepository(
                                        networkService: NetworkService()
                                    ),
                                    commonRepository: CommonRepository(
                                        networkService: NetworkService()
                                    ),
                                    commonViewModel: self.commonViewModel,
                                    navigationService: self.navigationService
                                )
                            case .qrCodeScreen(
                                let id,
                                let bcTemplateType,
                                let jobTitle
                            ):
                                QRCodePageView(
                                    id: id,
                                    bcTemplateType: bcTemplateType,
                                    jobTitle: jobTitle
                                )
                            case .settingsScreen:
                                SettingsPageView(
                                    repository: SettingsRepository(
                                        networkService: NetworkService()
                                    ),
                                    commonRepository: CommonRepository(
                                        networkService: NetworkService()
                                    ),
                                    commonViewModel: self.commonViewModel,
                                    navigationService: self.navigationService
                                )
                            case .serviceScreen(
                                let index
                            ):
                                ServicePageView(
                                    index: index,
                                    commonViewModel: self.commonViewModel
                                )
                            case .achievementScreen(
                                let index
                            ):
                                AchievementPageView(
                                    index: index,
                                    commonViewModel: self.commonViewModel
                                )
                            case .templatesScreen(
                                let isTeam
                            ):
                                TemplatesPageView(
                                    isTeam: isTeam
                                )
                            default:
                                SplashScreenView(
                                    commonViewModel: self.commonViewModel,
                                    navigationService: self.navigationService,
                                    locationManager: LocationManager(
                                        navigationService: self.navigationService,
                                        commonViewModel: self.commonViewModel,
                                        commonRepository: CommonRepository(
                                            networkService: NetworkService()
                                        )
                                    ),
                                    commonRepository: CommonRepository(
                                        networkService: NetworkService()
                                    )
                                )
                            }
                            if
                                i != .splashScreen &&
                                    i != .signInScreen &&
                                    i != .signUpScreen &&
                                    i != .restrorePasswordScreen &&
                                    !isKeyboardVisible {
                                CustomBottomNavigationBarView()
                            }
                            if self.isTutorial && i == .networkingScreen && (!self.commonViewModel.isCardsEmpty || !self.commonViewModel.isTeamsEmpty) {
                                TutorialView(isTutorial: self.$isTutorial)
                            }
                            CustomNotificationView(
                                text: "Запрос на вступление в команду успешно отправлен",
                                isError: false
                            )
                                .onReceive(self.commonViewModel.timer) {
                                    _ in
                                    if self.commonViewModel.isAlert {
                                        if self.commonViewModel.timeRemaining > 0 {
                                            self.commonViewModel.timeRemaining -= 1
                                                    }
                                    }
                                            }
                                .onReceive(self.commonViewModel.timer) {
                                    time in
                                    if self.commonViewModel.isAlert {
                                        if self.commonViewModel.timeRemaining == 0 {
                                            self.commonViewModel.timer.connect().cancel()
                                            self.commonViewModel.isAlert = false
                                                    }
                                    }
                                            }

                            .offset(
                                y: self.commonViewModel.isAlert ? (-UIScreen.main.bounds.size.height + self.safeAreaInsets.top + 100) : -1000
                            )
                                .transition(.move(edge: .top))
                            
                        }
                        .navigationBarBackButtonHidden(true)
                        .frame(
                            maxWidth: UIScreen.main.bounds.size.width,
                            maxHeight: UIScreen.main.bounds.size.height
                        )
                    }
                    .navigationBarBackButtonHidden(true)
            }
            .onAppear {
                print("рвфрвфырфвррвы \(delegate.url)")
            }
            .onReceive(keyboardPublisher) {
                newIsKeyboardVisible in
                isKeyboardVisible = newIsKeyboardVisible
            }
            .onOpenURL { url in
                print("App was opened via URL: \(url)")
                //GIDSignIn.sharedInstance.handle(url)
                handleIncomingURL(url)
            }
            .onAppear {
                print(UserDefaults.standard.string(forKey: "access_token"))
                if UserDefaults.standard.string(forKey: "access_token") == nil {
                    self.navigationService.navigate(to: .signInScreen)
                }
                else {
                    self.navigationService.navigate(to: .splashScreen)
                }
            }
            .environmentObject(navigationService)
            .environmentObject(commonViewModel)
            .environment(\.sizeCategory, .medium)
            .task {
                await self.notificationManager.getAuthStatus()
            }
        }
    }
}
