//import Foundation
//import FirebaseCore
//import FirebaseAuth
//import CryptoKit
//import AuthenticationServices
//import GoogleSignIn
//
//class AuthService: NSObject, ObservableObject, ASAuthorizationControllerDelegate  {
//  
//  // Password account sign in...
//
//  // Apple sign in...
//
//  func googleSignIn() {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//        // Create Google Sign In configuration object.
//        let config = GIDConfiguration(clientID: clientID)
//        
//        // As you’re not using view controllers to retrieve the presentingViewController, access it through
//        // the shared instance of the UIApplication
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
//        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
//
//        // Start the sign in flow!
//        GIDSignIn.sharedInstance.signIn(with: config, presenting: rootViewController) { [unowned self] user, error in
//
//          if let error = error {
//              print("Error doing Google Sign-In, \(error)")
//              return
//          }
//
//          guard
//            let authentication = user?.authentication,
//            let idToken = authentication.idToken
//          else {
//            print("Error during Google Sign-In authentication, \(error)")
//            return
//          }
//
//          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                         accessToken: authentication.accessToken)
//            
//            
//            // Authenticate with Firebase
//            Auth.auth().signIn(with: credential) { authResult, error in
//                if let e = error {
//                    print(e.localizedDescription)
//                }
//               
//                print("Signed in with Google")
//            }
//        }
//    }
//}
