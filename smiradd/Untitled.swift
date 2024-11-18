import Combine
import VK_ios_sdk

class VKAuthViewModel: NSObject, ObservableObject, VKSdkDelegate, VKSdkUIDelegate {
    @Published var isLoggedIn = false

    private let sdkInstance = VKSdk.initialize(withAppId: "YOUR_APP_ID")

    override init() {
        super.init()
        sdkInstance?.register(self)
        sdkInstance?.uiDelegate = self
        VKSdk.wakeUpSession(["friends"]) { (state, error) in
            if state == .authorized {
                self.isLoggedIn = true
            }
        }
    }

    func login() {
        VKSdk.authorize(["friends"], with: .disableSafariController)
    }

    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            isLoggedIn = true
        }
    }

    func vkSdkUserAuthorizationFailed() {
        isLoggedIn = false
    }

    func vkSdkShouldPresent(_ controller: UIViewController!) {
        UIApplication.shared.windows.first?.rootViewController?.present(controller, animated: true, completion: nil)
    }

    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        // Handle captcha if needed
    }
}
