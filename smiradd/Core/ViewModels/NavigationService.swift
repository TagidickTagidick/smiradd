import SwiftUI

final class NavigationService: ObservableObject {
    public enum Destination: Hashable {
        case splashScreen
        case signInScreen
        case signUpScreen
        case homeScreen
        case networkingScreen
        case cardScreen(
            cardId: String,
            cardType: CardType
        )
        case profileScreen
        case favoritesScreen
        case filterScreen(isFavorites: Bool)
        case serviceScreen
        case settingsScreen
        case qrCodeScreen
        case notificationsScreen
        case teamScreen(
            teamId: String,
            teamType: CardType
        )
    }
    
    @Published var navPath = NavigationPath()
    
    @Published var index: Int = 0
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
