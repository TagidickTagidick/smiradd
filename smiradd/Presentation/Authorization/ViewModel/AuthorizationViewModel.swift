import SwiftUI
import FirebaseAuth
import Firebase
import GoogleSignIn
import GoogleSignInSwift

class AuthorizationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var isLoading: Bool = false
    
    @Published var emailIsError: Bool = false
    @Published var passwordIsError: Bool = false
    
    @Published var passwordIsShown: Bool = false
    
    var isSignUp = false
    
    private let repository: IAuthorizationRepository
    private let navigationService: NavigationService
    
    init(
        repository: IAuthorizationRepository,
        isSignUp: Bool,
        navigationService: NavigationService
    ) {
        self.repository = repository
        self.isSignUp = isSignUp
        self.navigationService = navigationService
    }
    
    func changeAuthorization() {
        self.navigationService.navigate(
            to: self.isSignUp
            ? .signInScreen
            : .signUpScreen
        )
    }
    
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            return
        }
        
        self.isLoading = true
        self.repository.signInWithEmail(email: email, password: password) { [self] result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let authorizationModel):
                    UserDefaults.standard.set(
                        authorizationModel.access_token,
                        forKey: "access_token"
                    )
                    UserDefaults.standard.set(
                        authorizationModel.refresh_token,
                        forKey: "refresh_token"
                    )
                    self.navigationService.navigate(to: .networkingScreen)
                    break
                case .failure(let errorModel):
                    if (errorModel.statusCode == 404) {
                        self.emailIsError = true
                        break
                    }
                    
                    if (errorModel.statusCode == 400) {
                        self.passwordIsError = true
                        break
                    }
                    
                    break
                }
            }
        }
    }
    
    func signInWithGoogle() {
        isLoading = true
        
        guard let rootViewController = (UIApplication.shared.connectedScenes.first
                                        as? UIWindowScene)?.windows.first?.rootViewController
        else {return}
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController) { signInResult, error in
                if let error = error {
                    return
                }
                
                guard let user = signInResult?.user,
                      let idToken = user.idToken else { return }
                
                let accessToken = user.accessToken
                
                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken.tokenString,
                    accessToken: accessToken.tokenString
                )
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    self.repository.signInWithEmail(
                        email: authResult?.user.email ?? "",
                        password: authResult?.user.uid ?? "",
                        completion: {
                            [self] result in
                            DispatchQueue.main.async {
                                self.isLoading = false
                                switch result {
                                case .success:
                                    print(result)
                                    break
                                case .failure(let error):
                                    // Handle error
                                    break
                                }
                            }
                        }
                    )
                }
            }
    }
}
