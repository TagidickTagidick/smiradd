import Foundation

class NetworkingRepository: INetworkingRepository {
    private let networkService: INetworkService
    
    init(networkService: INetworkService) {
        self.networkService = networkService
    }
    
    func postClear(
        isTeam: Bool,
        completion: @escaping (Result<DetailsModel, Error>) -> Void
    ) {
        self.networkService.post(
            url: "networkingv2/clear\(isTeam ? "?team_seek=team" : "")",
            body: nil
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
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
}
