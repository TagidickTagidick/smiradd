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
    func application(_ application: UIApplication,
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
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        // Handle other custom URL types.
        
        // If not handled by this app, return false.
        return false
    }
}

@main
struct smiraddApp: App, KeyboardReadable {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @ObservedObject var navigationService = NavigationService()
    
    @State private var scrollOffset: CGFloat = 0
    
    @StateObject var profileViewModel: ProfileViewModel
    
    @StateObject var favoritesSettings = FavoritesSettings()
    
    @State private var isEnabled: Bool = false
    @State private var isKeyboardVisible: Bool = false
    
    @State private var isTutorial: Bool = !UserDefaults.standard.bool(forKey: "first_time")
    
    init() {
        _profileViewModel = StateObject(
            wrappedValue: ProfileViewModel(
                    repository: ProfileRepository(
                        networkService: NetworkService()
                    ),
                    navigationService: NavigationService()
                )
        )
    }
    
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
                                SplashScreen()
                            case .signInScreen:
                                AuthorizationPageView(
                                    isSignUp: false,
                                    repository: AuthorizationRepository(
                                        networkService: NetworkService()
                                    ),
                                    navigationService: navigationService
                                )
                            case .signUpScreen:
                                AuthorizationPageView(
                                    isSignUp: true,
                                    repository: AuthorizationRepository(
                                        networkService: NetworkService()
                                    ),
                                    navigationService: navigationService
                                )
                            case .networkingScreen:
                                NetworkingPageView(
                                    repository: MockNetworkRepository(),
                                    navigationService: navigationService
                                )
                            case .cardScreen(let cardId, let cardType):
                                CardPageView(
                                    repository: CardRepository(
                                        networkService: NetworkService()
                                    ),
                                    navigationService: navigationService,
                                    cardId: cardId,
                                    cardType: cardType
                                )
                            case .settingsScreen:
                                SettingsPageView()
                            case .profileScreen:
                                ProfilePageView()
                            case .favoritesScreen:
                                FavoritesScreen()
                            case .filterScreen:
                                FilterScreen()
                            case .serviceScreen:
                                ServicePageView()
                            case .qrCodeScreen:
                                QRCodePageView()
                            case .notificationsScreen:
                                NotificationsPageView()
                            default:
                                SplashScreen()
                            }
                            if
                                i != .splashScreen &&
                                    i != .signInScreen &&
                                    i != .signUpScreen &&
                                    i != .qrCodeScreen &&
                                    !isKeyboardVisible {
                                CustomBottomNavigationBar()
                            }
                            if isTutorial && i == .networkingScreen {
                                TutorialView(isTutorial: $isTutorial)
                            }
                        }
                        .navigationBarBackButtonHidden(true)
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                    .navigationBarBackButtonHidden(true)
            }
            .onAppear {
                let accessToken = UserDefaults.standard.string(forKey: "access_token")
                if accessToken == nil {
                    navigationService.navigate(to: .signInScreen)
                }
                else {
                    let body: [String: Double] = [
                        "latitude": 0,
                        "longitude": 0,
                    ]
                    let finalBody = try! JSONSerialization.data(withJSONObject: body)
                    let networkService = NetworkService()
                    
                    navigationService.navigate(to: .networkingScreen)
//                    networkClient.post(url: "networking/mylocation?code=9933") { result in
//                        DispatchQueue.main.async {
//                            switch result {
//                                case .success(let response):
//                                    print("да")
//                                    //healthCheckResult = "Health Check Success: \(response)"
//                                case .failure(let error):
//                                    print(error.message)
//                                        //healthCheckResult = "Health Check Failed: \(error.message)"
//                                }
//                            }
//                    }
//                    makeRequest(
//                        path: "networking/mylocation?code=9933",
//                        method: .post,
//                        body: finalBody
//                    ) { (result: Result<LocationModel, Error>) in
//                        DispatchQueue.main.async {
//                            switch result {
//                            case .success(let cards):
//                                makeRequest(
//                                    path: "templates",
//                                    method: .get
//                                ) { (result: Result<[TemplateModel], Error>) in
//                                    switch result {
//                                    case .success(let templates):
//                                        DispatchQueue.main.async {
//                                            self.profileSettings.templates = templates
//                                            navigationService.navigate(to: .networkingScreen)
//                                        }
//                                    case .failure(let error):
//                                        //                        if error.localizedDescription == "The Internet connection appears to be offline." {
//                                        //                            self.pageType = .internetError
//                                        //                        }
//                                        //                        else {
//                                        //                            self.pageType = .nothingHere
//                                        //                        }
//                                        print(error.localizedDescription)
//                                    }
//                                }
//                                print("success")
//                            case .failure(let error):
//                                //                        if error.localizedDescription == "The Internet connection appears to be offline." {
//                                //                            self.pageType = .internetError
//                                //                        }
//                                //                        else {
//                                //                            self.pageType = .nothingHere
//                                //                        }
//                                print(error.localizedDescription)
//                            }
//                        }
//                    }
                }
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
                      GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                        // Check if `user` exists; otherwise, do something with `error`
                      }
                    }
            .environmentObject(navigationService)
            .environmentObject(profileViewModel)
            .environmentObject(favoritesSettings)
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
