import SwiftUI

final class Router: ObservableObject {
    
    public enum Destination: Hashable {
        case splashScreen
        case signInScreen
        case signUpScreen
        case homeScreen
        case networkingScreen
        case cardScreen
        case templatesScreen
        case profileScreen
        case favoritesScreen
        case filterScreen
        case achievementScreen
        case serviceScreen
        case settingsScreen
        case qrCodeScreen
        case notificationsScreen
    }
    
    @Published var navPath = NavigationPath()
    
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
