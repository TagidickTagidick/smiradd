import SwiftUI

struct HomeScreen: View {
    @State private var index: Int = 0
    
    @ObservedObject var networkingRouter = Router()
    
    var body: some View {
        ZStack (alignment: .bottom) {
            switch index {
            case 0:
                NavigationStack(path: $networkingRouter.navPath) {
                    Spacer()
                    .navigationDestination(for: Router.Destination.self) { i in
                        switch i {
                            case .networking:
                                SplashScreen()
                            case .cardScreen:
                                
                            default:
                                NetworkingScreen()
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                }
                .environmentObject(networkingRouter)
            case 1:
                ProfileScreen()
            case 2:
                FavoritesScreen()
            default:
                NetworkingScreen()
            }
            HStack {
                VStack {
                    if index == 0 {
                        Image("networking_active")
                    }
                    else {
                        Image("networking")
                    }
                    Spacer()
                        .frame(height: 4)
                    Text("Нетворкинг")
                        .font(
                            .custom(
                                "Roboto-\(index == 0 ? "Medium" : "Regular")",
                                size: 12
                            )
                        )
                        .foregroundStyle(textDefault)
                }
                .onTapGesture {
                    self.index = 0
                }
                VStack {
                    if index == 1 {
                        Image("profile_active")
                    }
                    else {
                        Image("profile")
                    }
                    Spacer()
                        .frame(height: 4)
                    Text("Профиль")
                        .font(
                            .custom(
                                "Roboto-\(index == 1 ? "Medium" : "Regular")",
                                size: 12
                            )
                        )
                        .foregroundStyle(textDefault)
                }
                .onTapGesture {
                    self.index = 1
                }
                VStack {
                    if index == 2 {
                        Image("favorites_active")
                    }
                    else {
                        Image("favorites")
                    }
                    Spacer()
                        .frame(height: 4)
                    Text("Избранное")
                        .font(
                            .custom(
                                "Roboto-\(index == 2 ? "Medium" : "Regular")",
                                size: 12
                            )
                        )
                        .foregroundStyle(textDefault)
                }
                .onTapGesture {
                    self.index = 2
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: 58
            )
            .background(.white)
            .shadow(
                color: textDefault.opacity(0.04),
                radius: 1,
                x: 0,
                y: -1
            )
            .shadow(
                color: textDefault.opacity(0.08),
                radius: 16
            )
            .padding(.bottom)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .navigationBarBackButtonHidden(true)
    }
}
