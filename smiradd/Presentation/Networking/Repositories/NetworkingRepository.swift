import Foundation

class NetworkingRepository: INetworkingRepository {
    private let networkService: INetworkService
    
    init(networkService: INetworkService) {
        self.networkService = networkService
    }
    
    func getAroundMeCards(
        specificity: [String],
        code: String,
        completion: @escaping (Result<[CardModel], Error>) -> Void
    ) {
        var specificityString = ""
        
        if !specificity.isEmpty {
            specificityString = specificity.first!
            
            for i in 1 ..< specificity.count {
                specificityString = specificityString + ",\(specificity[i])"
            }
        }
        
        self.networkService.get(
            url: "networkingv2/aroundme/100\(code.isEmpty ? "" : "?code=\(code)\(specificityString.isEmpty ? "" : "\(code.isEmpty ? "?" : "&")specificity=\(specificityString)")")"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(
                        withJSONObject: response["payload"] ?? [],
                        options: []
                    )
                    let cardModels = try JSONDecoder().decode(
                        [CardModel].self,
                        from: data
                    )
                    completion(.success(cardModels))
                } catch {
                    print("рвыфрвыфр \(error)")
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func getAroundMeTeams(
        specificity: [String],
        code: String,
        completion: @escaping (Result<[TeamModel], Error>) -> Void
    ) {
        var specificityString = ""
        
        if !specificity.isEmpty {
            specificityString = specificity.first!
            
            for i in 1 ..< specificity.count {
                specificityString = specificityString + ",\(specificity[i])"
            }
        }
        
        self.networkService.get(
            url: "networkingv2/aroundme/100?team_seek=team\(code.isEmpty ? "" : "&code=\(code)\(specificityString.isEmpty ? "" : "&specificity=\(specificityString)")")"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(
                        withJSONObject: response["payload"] ?? [],
                        options: []
                    )
                    let teamModels = try JSONDecoder().decode(
                        [TeamModel].self,
                        from: data
                    )
                    completion(.success(teamModels))
                } catch {
                    print("рвыфрвыфр \(error)")
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func patchAroundme(
        id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        self.networkService.patch(
            url: "networkingv2/aroundme",
            body: ["cards": [id]]
        ) { result in
            switch result {
            case .success(let response):
                completion(.success(()))
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func postClear(
        isTeam: Bool,
        completion: @escaping (Result<DetailModel, Error>) -> Void
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
                    let detailModel = try JSONDecoder().decode(
                        DetailModel.self,
                        from: data
                    )
                    completion(.success(detailModel))
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
