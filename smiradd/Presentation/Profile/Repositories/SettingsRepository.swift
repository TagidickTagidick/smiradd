class SettingsRepository: ISettingsRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
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
