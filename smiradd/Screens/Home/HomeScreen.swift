import SwiftUI

struct HomeScreen: View {
    @State private var index: Int = 0
    
    @ObservedObject var networkingRouter = Router()
    @ObservedObject var profileRouter = Router()
    @ObservedObject var favoritesRouter = Router()
    
    var body: some View {
        ZStack (alignment: .bottom) {
            NavigationStack(path: $networkingRouter.navPath) {
                NetworkingScreen()
                                .navigationDestination(for: Router.Destination.self) { i in
                                    switch i {
                                        case .networkingScreen:
                                            NetworkingScreen()
                                        case .cardScreen:
                                            CardScreen()
                                        default:
                                            NetworkingScreen()
                                    }
                                }
                                .navigationBarBackButtonHidden(true)
                            }
                            .environmentObject(networkingRouter)
                            .onAppear {
                                print("рырыр")
                                networkingRouter.navigate(to: .networkingScreen)
                            }
            switch index {
            case 0:
                NavigationStack(path: $networkingRouter.navPath) {
                    NetworkingScreen()
                    .navigationDestination(for: Router.Destination.self) { i in
                        switch i {
                            case .networkingScreen:
                                NetworkingScreen()
                            case .cardScreen:
                                CardScreen()
                            default:
                                NetworkingScreen()
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                }
                .environmentObject(networkingRouter)
            case 1:
                NavigationStack(path: $profileRouter.navPath) {
                    Spacer()
                    .navigationDestination(for: Router.Destination.self) { i in
                        switch i {
                            case .profileScreen:
                                ProfileScreen()
                            case .editingProfileScreen:
                                EditingProfileScreen()
                            default:
                                ProfileScreen()
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                }
                .environmentObject(profileRouter)
            case 2:
                NavigationStack(path: $favoritesRouter.navPath) {
                    Spacer()
                    .navigationDestination(for: Router.Destination.self) { i in
                        switch i {
                            case .favoritesScreen:
                                FavoritesScreen()
                            case .filterScreen:
                                CardScreen()
                            default:
                                FavoritesScreen()
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                }
                .environmentObject(favoritesRouter)
            default:
                NetworkingScreen()
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .navigationBarBackButtonHidden(true)
    }
}
