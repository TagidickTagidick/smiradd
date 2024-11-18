import FirebaseCore
import Firebase
import FirebaseMessaging
import SDWebImage
import SDWebImageSwiftUI
import UserNotifications

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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            let userInfo = notification.request.content.userInfo
        
        print(userInfo["text"])

            // Print the message data
            if let messageData = userInfo["text"] as? [String: Any] {
                print("Message data: \(messageData)")
            }

            // Let the app present the notification
            completionHandler([[.alert, .sound]])
        }
    
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        if let fcm = Messaging.messaging().fcmToken {
            if UserDefaults.standard.string(forKey: "access_token") != nil {
                print("firebase token received \(fcm)")
                NetworkService().post(
                    url: "firebase-create",
                    body: ["firebase_token": fcm]
                ) { _ in
                    
                }
            }
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
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

//          if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//          }

          print(userInfo)

          completionHandler(UIBackgroundFetchResult.newData)
        }
}

//@available(iOS 10, *)
//extension AppDelegate : UNUserNotificationCenterDelegate {
//
//  // Receive displayed notifications for iOS 10 devices.
//  func userNotificationCenter(_ center: UNUserNotificationCenter,
//                              willPresent notification: UNNotification,
//    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//    let userInfo = notification.request.content.userInfo
//
//    if let messageID = userInfo[gcmMessageIDKey] {
//        print("Message ID: \(messageID)")
//    }
//
//    print(userInfo)
//
//    // Change this to your preferred presentation option
//    completionHandler([[.banner, .badge, .sound]])
//  }
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//
//    }
//
//  func userNotificationCenter(_ center: UNUserNotificationCenter,
//                              didReceive response: UNNotificationResponse,
//                              withCompletionHandler completionHandler: @escaping () -> Void) {
//    let userInfo = response.notification.request.content.userInfo
//
//    if let messageID = userInfo[gcmMessageIDKey] {
//      print("Message ID from userNotificationCenter didReceive: \(messageID)")
//    }
//
//    print(userInfo)
//
//    completionHandler()
//  }
//}
