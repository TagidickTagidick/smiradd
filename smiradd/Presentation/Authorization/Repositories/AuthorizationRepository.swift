import Foundation

class AuthorizationRepository: IAuthorizationRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func signUpWithEmail(email: String, password: String, completion: @escaping (Result<AuthorizationModel, Error>) -> Void) {
        self.networkService.post(
            url: "auth/registration",
            body: [
                "email": email,
                "password": password
            ]
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(withJSONObject: response, options: [])
                    let authorizationModel = try JSONDecoder().decode(AuthorizationModel.self, from: data)
                    completion(.success(authorizationModel))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func signInWithEmail(email: String, password: String, completion: @escaping (Result<AuthorizationModel, ErrorModel>) -> Void) {
        networkService.post(
            url: "auth/login",
            body: [
                "email": email,
                "password": password
            ]
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(withJSONObject: response, options: [])
                    let authorizationModel = try JSONDecoder().decode(AuthorizationModel.self, from: data)
                    completion(.success(authorizationModel))
                } catch {
                    completion(.failure(ErrorModel(statusCode: 500, message: "Failed to parse")))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func signInWithGoogle(completion: @escaping (Result<Void, Error>) -> Void) {
        // Implement sign-in with Google logic...
    }
}
