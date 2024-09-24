import SwiftUI
import FirebaseCore
import Firebase
import FirebaseMessaging
import GoogleSignIn

extension View {
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}

//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
//    func application(
//        _ application: UIApplication,
//        open url: URL,
//        options: [UIApplication.OpenURLOptionsKey : Any] = [:],
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//            //application.registerForRemoteNotifications()
//            FirebaseApp.configure()
//            print("рырыр")
////            Messaging.messaging().delegate = self
////            UNUserNotificationCenter.current().delegate = self
//            return true
//        }
//
//    @available(iOS 9.0, *)
//    func application(_ application: UIApplication, open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey: Any])
//    -> Bool {
//        return GIDSignIn.sharedInstance.handle(url)
//    }
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
//    }
//
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        if let fcm = Messaging.messaging().fcmToken {
//            print("fcm", fcm)
//        }
//        else {
//            print("ырыр")
//        }
//    }
//}

class AppDelegate: NSObject, UIApplicationDelegate {
    @Published var url: URL?
    func application(
        _ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
            } else {
                // Show the app's signed-in state.
            }
        }
        
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
//        var handled: Bool
//        
//        handled = GIDSignIn.sharedInstance.handle(url)
//        if handled {
//            return true
//        }
        self.url = url
        
        return false
    }
}

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
    
    @StateObject var locationManager = LocationManager()
    
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
                                    locationManager: self.locationManager,
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
                                    locationManager: self.locationManager,
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
                                    locationManager: self.locationManager,
                                    commonRepository: CommonRepository(
                                        networkService: NetworkService()
                                    )
                                )
                            case .networkingScreen:
                                NetworkingPageView(
                                    repository: NetworkingRepository(
                                        networkService: NetworkService()
                                    ),
                                    navigationService: self.navigationService,
                                    locationManager: self.locationManager,
                                    commonViewModel: self.commonViewModel,
                                    commonRepository: CommonRepository(
                                        networkService: NetworkService()
                                    )
                                )
                            case .cardScreen(let cardId, let cardType):
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
                                    navigationService: navigationService,
                                    commonSpecifities: isFavorites ? self.commonViewModel.favoritesSpecificities : self.commonViewModel.networkingSpecificities,
                                    isFavorites: isFavorites
                                )
                            case .qrCodeScreen:
                                QRCodePageView()
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
                            default:
                                SplashScreenView(
                                    commonViewModel: self.commonViewModel,
                                    navigationService: self.navigationService,
                                    locationManager: self.locationManager,
                                    commonRepository: CommonRepository(
                                        networkService: NetworkService()
                                    )
                                )
                            }
                            if
                                i != .splashScreen &&
                                    i != .signInScreen &&
                                    i != .signUpScreen &&
                                    i != .qrCodeScreen &&
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
                GIDSignIn.sharedInstance.handle(url)
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
        }
    }
}

struct ContentView: View {
    @StateObject var notificationManager = NotificationManager()
    var body: some View{
        VStack{
            Button("Request Notification"){
                Task{
                    await notificationManager.request()
                }
            }
            .buttonStyle(.bordered)
            .disabled(notificationManager.hasPermission)
            .task {
                await notificationManager.getAuthStatus()
            }
        }
    }
    
}
