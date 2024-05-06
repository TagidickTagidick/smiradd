import SwiftUI
import FirebaseCore
import Firebase
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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:],
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
    
    @available(iOS 9.0, *)
        func application(_ application: UIApplication, open url: URL,
                         options: [UIApplication.OpenURLOptionsKey: Any])
          -> Bool {
          return GIDSignIn.sharedInstance.handle(url)
        }
}

@main
struct smiraddApp: App, KeyboardReadable {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @ObservedObject var router = Router()
    
    @State private var scrollOffset: CGFloat = 0
    
    @StateObject var cardSettings = CardSettings()
    @StateObject var profileSettings = ProfileSettings()
    @StateObject var favoritesSettings = FavoritesSettings()
    
    @State private var isEnabled: Bool = false
    @State private var isKeyboardVisible: Bool = false
    
    @StateObject var locationManager = LocationManager()
    
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
        
        cardSettings.cardId = recipeName
        router.navigate(to: .cardScreen)
    }
    
    var body: some Scene {
        WindowGroup {
                NavigationStack(path: $router.navPath) {
                    Spacer()
                    .navigationDestination(for: Router.Destination.self) { i in
                        ZStack (alignment: .bottom) {
                            switch i {
                                case .splashScreen:
                                    SplashScreen()
                                case .signInScreen:
                                    AuthorizationScreen(isSignUp: false)
                                case .signUpScreen:
                                    AuthorizationScreen(isSignUp: true)
                            case .networkingScreen:
                                NetworkingScreen()
                                case .cardScreen:
                                    CardScreen()
                            case .settingsScreen:
                                SettingsScreen()
                            case .templatesScreen:
                                TemplatesScreen()
                                case .profileScreen:
                                    ProfileScreen()
                                case .favoritesScreen:
                                    FavoritesScreen()
                                case .filterScreen:
                                    FilterScreen()
                            case .achievementScreen:
                                AchievementScreen()
                            case .serviceScreen:
                                ServiceScreen()
                            case .qrCodeScreen:
                                QRCodeScreen()
                            case .notificationsScreen:
                                NotificationsScreen()
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
                            if !profileSettings.isTutorial && i == .networkingScreen {
                                TutorialScreen()
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
                    router.navigate(to: .signInScreen)
                }
                else {
                    locationManager.getLocation()
                    if let location = locationManager.location {
                        let body: [String: Double] = [
                            "latitude": location.coordinate.latitude,
                            "longitude": location.coordinate.longitude
                        ]
                        let finalBody = try! JSONSerialization.data(withJSONObject: body)
                        makeRequest(
                            path: "networking/mylocation",
                            method: .post,
                            body: finalBody
                        ) { (result: Result<LocationModel, Error>) in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let cards):
                                    makeRequest(
                                        path: "templates",
                                        method: .get,
                                        isProd: true
                                    ) { (result: Result<[TemplateModel], Error>) in
                                        DispatchQueue.main.async {
                                            switch result {
                                            case .success(let templates):
                                                self.profileSettings.templates = templates
                                                makeRequest(
                                                    path: "cards",
                                                    method: .get
                                                ) { (result: Result<[CardModel], Error>) in
                                                    DispatchQueue.main.async {
                                                        switch result {
                                                        case .success(let cards):
                                                            self.profileSettings.cards = cards
                                                            router.navigate(to: .networkingScreen)
                                                        case .failure(let error):
                                    //                        if error.localizedDescription == "The Internet connection appears to be offline." {
                                    //                            self.pageType = .internetError
                                    //                        }
                                    //                        else {
                                    //                            self.pageType = .nothingHere
                                    //                        }
                                                            print(error.localizedDescription)
                                                        }
                                                    }
                                                }
                                                router.navigate(to: .networkingScreen)
                                            case .failure(let error):
                        //                        if error.localizedDescription == "The Internet connection appears to be offline." {
                        //                            self.pageType = .internetError
                        //                        }
                        //                        else {
                        //                            self.pageType = .nothingHere
                        //                        }
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                    print("success")
                                case .failure(let error):
            //                        if error.localizedDescription == "The Internet connection appears to be offline." {
            //                            self.pageType = .internetError
            //                        }
            //                        else {
            //                            self.pageType = .nothingHere
            //                        }
                                    print(error.localizedDescription)
                                }
                            }
                        }
                                    print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
                                } else {
                                    print("Fetching location...")
                                }
                }
            }
            .onReceive(keyboardPublisher) {
                newIsKeyboardVisible in
                isKeyboardVisible = newIsKeyboardVisible
            }
            .onOpenURL { incomingURL in
                print("App was opened via URL: \(incomingURL)")
                handleIncomingURL(incomingURL)
            }
            .environmentObject(router)
            .environmentObject(cardSettings)
            .environmentObject(profileSettings)
            .environmentObject(favoritesSettings)
            .environmentObject(locationManager)
        }
    }
}
