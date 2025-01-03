import Foundation
import Combine

class RestorePasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var emailIsError: Bool = false
    @Published var emailErrorText: String = ""
    @Published var isValidEmail: Bool = false
    
    @Published var timeRemaining: Int = 0
    
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>? = nil
    
    @Published var showPinCode: Bool = false
    @Published var code: String = ""
    
    @Published var isSheet: Bool = false
    
    private let repository: IRestorePasswordRepository
    private let navigationService: NavigationService
    
    init(
        repository: IRestorePasswordRepository,
        navigationService: NavigationService
    ) {
        self.repository = repository
        self.navigationService = navigationService
    }
    
    func sendCode() {
        if self.timeRemaining != 0 || !self.isValidEmail {
            return
        }
        
        self.repository.postEmail(
            email: self.email
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.showPinCode = true
                    self.timeRemaining = 60
                    self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
            }
        }
    }
    
    func confirmCode() {
        if self.code.count != 4 {
            return
        }
        
        self.repository.postCodeVerify(
            code: self.code,
            email: self.email
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.isSheet = true
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
            }
        }
    }
    
    func navigateToSignIn() {
        self.isSheet = false
        
        self.navigationService.navigate(to: .signInScreen)
    }
    
    func checkEmail() {
        let regex = try! NSRegularExpression(
            pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$",
            options: [.caseInsensitive]
        )
        self.isValidEmail = regex.firstMatch(
            in: self.email,
            options: [],
            range: NSRange(
                location: 0,
                length: self.email.utf16.count
            )
        ) != nil
    }
}
