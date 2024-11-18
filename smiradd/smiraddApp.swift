import SwiftUI
import FirebaseCore
import Firebase
import FirebaseMessaging
import SDWebImage
import SDWebImageSwiftUI
import CardStack

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

        self.navigationService.navigate(
            to: .cardScreen(
                cardId: recipeName,
                cardType: .userCard
            )
        )
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
                                    ),
                                    commonViewModel: self.commonViewModel
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
                            if self.isTutorial && i == .networkingScreen && (self.commonViewModel.networkingCards.numberOfElements != 0 || self.commonViewModel.networkingTeams.numberOfElements != 0) {
                                TutorialView(isTutorial: self.$isTutorial)
                            }
                                VStack {
                                    if self.commonViewModel.isAlert {
                                    CustomNotificationView()
                                        .offset(y: self.commonViewModel.alertOffset.height)
                                        .gesture(
                                            DragGesture()
                                                .onChanged { gesture in
                                                    if gesture.translation.height <= 0 {
                                                        self.commonViewModel.alertOffset = gesture.translation
                                                    }
                                                }
                                                .onEnded { _ in
                                                    if abs(self.commonViewModel.alertOffset.height) > 50 {
                                                        withAnimation {
                                                            self.commonViewModel.isAlert = false
                                                        }
                                                    } else {
                                                        withAnimation {
                                                            self.commonViewModel.alertOffset = .zero
                                                        }
                                                    }
                                                }
                                        )
                                        .transition(.move(edge: .top))
                                        .animation(.spring())
                                        .padding()
                                    Spacer()
                                }
                            }
//                            CustomNotificationView()
//                            .offset(
//                                y: self.commonViewModel.isAlert ? (-UIScreen.main.bounds.size.height + self.safeAreaInsets.top + 100) : -1000
//                            )
//                                .transition(.move(edge: .top))
//                                .animation(.spring())
                            
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
                if url.absoluteString.contains("https://smiradd.ru/cards/") {
                    self.navigationService.navigate(
                        to: .cardScreen(
                            cardId: String(url.absoluteString.split(separator: "/").last!),
                            cardType: .userCard
                        )
                    )
                }
                if url.absoluteString.contains("https://smiradd.ru/teams/invite/") {
                    let cardId = String(url.absoluteString.split(separator: "/").last!)
                    if self.commonViewModel.teamMainModel.team.id != cardId {
                        CommonRepository(
                            networkService: NetworkService()
                        ).invite(url: String(url.absoluteString.split(separator: "/").last!)) {
                            result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let cardModels):
                                    self.commonViewModel.showAlert(
                                        isError: false,
                                        text: "Вы добавлены в команду"
                                    )
                                    break
                                case .failure(let error):
                                    break
                                }
                            }
                        }
                    }
                }
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

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Home View")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: DetailView()) {
                    Text("Go to Detail View")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct DetailView: View {
    var body: some View {
        VStack {
            Text("Detail View")
                .font(.largeTitle)
                .padding()

            // You can add more content here
        }
        .navigationTitle("Detail")
    }
}
