import SwiftUI

class CommonRepository: ICommonRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func uploadImage(
        image: UIImage,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        self.networkService.uploadImage(
            image: image
        ) {
            result in
            switch result {
            case .success(let response):
                completion(.success(response))
                break
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func uploadVideo(
        video: URL,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        self.networkService.uploadVideo(
            video: video
        ) {
            result in
            switch result {
            case .success(let response):
                completion(.success(response))
                break
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func getSpecificities(
        completion: @escaping (Result<[SpecificityModel], Error>) -> Void
    ) {
        self.networkService.get(
            url: "specifity"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(withJSONObject: response["payload"] ?? [], options: [])
                    let specificityModels = try JSONDecoder().decode([SpecificityModel].self, from: data)
                    completion(.success(specificityModels))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func getTemplates(
        completion: @escaping (Result<[TemplateModel], Error>) -> Void
    ) {
        self.networkService.get(
            url: "templates"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(
                        withJSONObject: response["payload"] ?? [],
                        options: []
                    )
                    let templateModels = try JSONDecoder().decode(
                        [TemplateModel].self,
                        from: data
                    )
                    completion(.success(templateModels))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func postMyLocation(
        latitude: Double,
        longitude: Double,
        code: String,
        completion: @escaping (Result<LocationModel, Error>) -> Void
    ) {
        self.networkService.post(
            url: "networking/mylocation\(code.isEmpty ? "" : "?code=\(code)")",
            body: [
                "latitude": 0,
                "longitude": 0
            ]
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(
                        withJSONObject: response,
                        options: []
                    )
                    let locationModel = try JSONDecoder().decode(
                        LocationModel.self,
                        from: data
                    )
                    completion(.success(locationModel))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func getCards(
        completion: @escaping (Result<[CardModel], Error>) -> Void
    ) {
        self.networkService.get(
            url: "cards"
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
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func postFavorites(
        cardId: String,
        completion: @escaping (Result<DetailsModel, Error>) -> Void
    ) {
        self.networkService.post(
            url: "cards/\(cardId)/favorites",
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
                    print("рвыфрвыфр \(error)")
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func invite(
        url: String,
        completion: @escaping (Result<DetailsModel, Error>) -> Void
    ) {
        self.networkService.post(
            url: "team/invite/\(url)",
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
                    print("рвыфрвыфр \(error)")
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func deleteFavorites(
        cardId: String,
        completion: @escaping (Result<DetailsModel, Error>) -> Void
    ) {
        self.networkService.delete(
            url: "cards/\(cardId)/favorites"
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
                    print("рвыфрвыфр \(error)")
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func getTeam(
        completion: @escaping (Result<TeamMainModel, Error>) -> Void
    ) {
        self.networkService.get(
            url: "team"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(
                        withJSONObject: response,
                        options: []
                    )
                    let teamMainModel = try JSONDecoder().decode(
                        TeamMainModel.self,
                        from: data
                    )
                    completion(.success(teamMainModel))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func postRequest(
        id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        self.networkService.post(
            url: "teams/\(id)/request",
            body: nil
        ) { result in
            switch result {
            case .success(let response):
                completion(.success(()))
            case .failure(let errorModel):
                completion(.failure(errorModel))
            }
        }
    }
    
    func postTeamInvite(
        id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        self.networkService.post(
            url: "team/\(id)/team_invite",
            body: nil
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
    
    func deleteTeam(
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        self.networkService.delete(
            url: "team"
        ) {
            result in
            switch result {
            case .success(_):
                completion(.success(()))
                break
            case .failure(let errorModel):
                completion(.failure(errorModel))
            }
        }
    }
    
    func deleteLeaveTeam(
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        self.networkService.delete(
            url: "team/leave"
        ) {
            result in
            switch result {
            case .success(_):
                completion(.success(()))
                break
            case .failure(let errorModel):
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
    
    func getNotifications(
        completion: @escaping (Result<NotificationsModel, ErrorModel>) -> Void
    ) {
        self.networkService.get(
            url: "notifications"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(
                        withJSONObject: response,
                        options: []
                    )
                    
                    let notificationModels = try JSONDecoder().decode(
                        NotificationsModel.self,
                        from: data
                    )
                    
                    completion(.success(notificationModels))
                } catch {
                    completion(
                        .failure(
                            ErrorModel(
                                statusCode: 500,
                                message: "Invalid json"
                            )
                        )
                    )
                }
            case .failure(let errorModel):
                completion(.failure(errorModel))
            }
        }
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
            url: "networkingv2/aroundme/30\(code.isEmpty ? "" : "?code=\(code)\(specificityString.isEmpty ? "" : "\(code.isEmpty ? "?" : "&")specificity=\(specificityString)")")"
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
            url: "networkingv2/aroundme/30?team_seek=team\(code.isEmpty ? "" : "&code=\(code)\(specificityString.isEmpty ? "" : "&specificity=\(specificityString)")")"
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
