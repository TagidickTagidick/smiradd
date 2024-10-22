import Foundation
import UserNotifications

@MainActor
class NotificationManager: ObservableObject {
    @Published private(set) var hasPermission = false
    
    init() {
        Task {
            await self.getAuthStatus()
        }
    }
    
    func request() async {
        do {
            try await UNUserNotificationCenter.current().requestAuthorization(
                options: [
                    .alert,
                    .badge,
                    .sound
                ]
            );
            await self.getAuthStatus()
        }
        catch {
            print(error)
        }
    }
    
    func getAuthStatus() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case .authorized, .ephemeral, .provisional:
            self.hasPermission = true
        case .notDetermined:
            self.hasPermission = false
        case .denied:
            self.hasPermission = false
        @unknown default:
            self.hasPermission = false
        }
    }
}
