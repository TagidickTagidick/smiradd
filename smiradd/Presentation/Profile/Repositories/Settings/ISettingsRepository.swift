class SettingsRepository: ISettingsRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func patchProfile(
        pictureUrl: String?,
        firstName: String,
        lastName: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        var body: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName
        ]
        
        if pictureUrl != nil {
            body["picture_url"] = "+" + pictureUrl!
        }
        
        self.networkService.patch(
            url: "profile",
            body: body
        ) { result in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
}
