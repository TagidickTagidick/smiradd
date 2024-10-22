import Foundation

class ProfileRepository: IProfileRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        self.networkService.get(
            url: "profile"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(
                        withJSONObject: response,
                        options: []
                    )
                    let profileModel = try JSONDecoder().decode(
                        ProfileModel.self,
                        from: data
                    )
                    completion(.success(profileModel))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
}
