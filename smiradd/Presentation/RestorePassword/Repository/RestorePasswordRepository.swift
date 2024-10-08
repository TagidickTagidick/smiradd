import Foundation

class RestorePasswordRepository: IRestorePasswordRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func postEmail(
        email: String,
        completion: @escaping (Result<DetailsModel, ErrorModel>) -> Void
    ) {
        self.networkService.post(
            url: "email",
            body: ["email": email]
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(
                        withJSONObject: response,
                        options: []
                    )
                    let detailsModel = try JSONDecoder().decode(
                        DetailsModel.self,
                        from: data
                    )
                    completion(.success(detailsModel))
                } catch {
                    completion(.failure(ErrorModel(
                        statusCode: 500,
                        message: "Failed to parse"
                    )))
                }
            case .failure(let errorModel):
                completion(
                    .failure(errorModel)
                )
            }
        }
    }
    
    func postCodeVerify(
        code: String,
        email: String,
        completion: @escaping (Result<DetailsModel, ErrorModel>) -> Void
    ) {
        networkService.post(
            url: "code/verify",
            body: [
                "code": code,
                "email": email
            ]
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(
                        withJSONObject: response,
                        options: []
                    )
                    let detailsModel = try JSONDecoder().decode(
                        DetailsModel.self,
                        from: data
                    )
                    completion(.success(detailsModel))
                } catch {
                    completion(.failure(ErrorModel(
                        statusCode: 500,
                        message: "Failed to parse"
                    )))
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
