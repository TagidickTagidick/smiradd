import SwiftUI

struct CustomBottomNavigationBar: View {
    @EnvironmentObject var router: NavigationService
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                if router.index == 0 {
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
                            "Roboto-\(router.index == 0 ? "Medium" : "Regular")",
                            size: 12
                        )
                    )
                    .foregroundStyle(textDefault)
            }
            .onTapGesture {
                router.navigateToRoot()
                router.navigate(to: .networkingScreen)
                router.index = 0
            }
            Spacer()
            VStack {
                if router.index == 1 {
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
                            "Roboto-\(router.index == 1 ? "Medium" : "Regular")",
                            size: 12
                        )
                    )
                    .foregroundStyle(textDefault)
            }
            .onTapGesture {
                router.navigateToRoot()
                router.navigate(to: .profileScreen)
                router.index = 1
            }
            Spacer()
            VStack {
                if router.index == 2 {
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
                            "Roboto-\(router.index == 2 ? "Medium" : "Regular")",
                            size: 12
                        )
                    )
                    .foregroundStyle(textDefault)
            }
            .onTapGesture {
                router.navigateToRoot()
                router.navigate(to: .favoritesScreen)
                router.index = 2
            }
            Spacer()
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
        .offset(y: 0)
    }
}
