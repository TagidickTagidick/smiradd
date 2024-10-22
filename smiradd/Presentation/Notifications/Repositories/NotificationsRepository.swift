import Foundation

class NotificationsRepository: INotificationsRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func patchNotification(
        id: String,
        accepted: Bool? = nil,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        self.networkService.patch(
            url: "notification/\(id)\(accepted == nil ? "" : "?accepted=\(accepted ?? false)")"
        ) {
            result in
            switch result {
            case .success(let response):
                completion(.success(()))
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
}
