import Foundation

class NetworkingRepository: INetworkingRepository {
    private let networkService: INetworkService
    
    init(networkService: INetworkService) {
        self.networkService = networkService
    }
    
    func getAroundMe(completion: @escaping (Result<[CardModel], Error>) -> Void) {
        self.networkService.get(
            url: "networkingv2/aroundme/10"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    guard let responseObject = response as? [String: Any] else {
                                        throw NSError(domain: "InvalidResponse", code: 0, userInfo: nil)
                                    }
                                    let data = try JSONSerialization.data(withJSONObject: responseObject["cards"]!, options: [])
                    print(responseObject["cards"])
                                    let cards = try JSONDecoder().decode([CardModel].self, from: data)
                    print(cards)
                                    for card in cards {
                                        if card.like == true {
                                            // Do something with liked cards
                                        }
                                    }
                    completion(.success(cards))
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
