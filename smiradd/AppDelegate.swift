import FirebaseCore
import Firebase
import FirebaseMessaging
import SDWebImage
import SDWebImageSwiftUI
import VKID

var firebaseToken = ""

class AppDelegate:
    NSObject,
    MessagingDelegate,
    UIApplicationDelegate,
    UNUserNotificationCenterDelegate
{
    @Published var url: URL?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [
            UIApplication.LaunchOptionsKey : Any
        ]? = nil
    ) -> Bool {
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        SDWebImageManager.defaultImageCache = SDImageCachesManager.shared
        
        return true
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: any Error
    ) {
        print("fail: \(error)")
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        print("apns received: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        if let fcm = Messaging.messaging().fcmToken {
            print("firebase token received")
            firebaseToken = fcm
        }
    }
    
    func application(
        _ app: UIApplication,
        open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
//        var handled: Bool
//
//        handled = GIDSignIn.sharedInstance.handle(url)
//        if handled {
//            return true
//        }
        self.url = url
        
        return false
    }
}
