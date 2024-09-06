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
                    let data = try JSONSerialization.data(withJSONObject: response, options: [])
                    let profileModel = try JSONDecoder().decode(ProfileModel.self, from: data)
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
    
    func getCards(completion: @escaping (Result<[CardModel], Error>) -> Void) {
        self.networkService.get(
            url: "cards"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(withJSONObject: response["payload"] ?? [], options: [])
                    let cardModels = try JSONDecoder().decode([CardModel].self, from: data)
                    completion(.success(cardModels))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func getNotifications(completion: @escaping (Result<NotificationsModel, Error>) -> Void) {
        self.networkService.get(
            url: "notifications"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(withJSONObject: response, options: [])
                    let notificationModels = try JSONDecoder().decode(NotificationsModel.self, from: data)
                    completion(.success(notificationModels))
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
