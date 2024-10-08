class SettingsRepository: ISettingsRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func patchResetPassword(
        password: String,
        completion: @escaping (Result<Void, ErrorModel>) -> Void
    ) {
        self.networkService.patch(
            url: "profile/reset/password",
            body: ["password": password]
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
    
    func postTickets(
        mainText: String,
        completion: @escaping (Error?) -> Void
    ) {
        self.networkService.post(
            url: "tickets",
            body: ["main_text": mainText]
        ) { result in
            switch result {
            case .success(_):
                completion(nil)
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(errorModel)
            }
        }
    }
}
