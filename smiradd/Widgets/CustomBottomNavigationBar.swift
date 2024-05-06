import SwiftUI

struct CustomBottomNavigationBar: View {
    @EnvironmentObject var router: Router
    
    @State private var index: Int = 0
    
    var body: some View {
        HStack {
            Spacer()
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
                router.navigateToRoot()
                router.navigate(to: .networkingScreen)
                self.index = 0
            }
            Spacer()
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
                router.navigateToRoot()
                router.navigate(to: .profileScreen)
                self.index = 1
            }
            Spacer()
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
                router.navigateToRoot()
                router.navigate(to: .favoritesScreen)
                self.index = 2
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
