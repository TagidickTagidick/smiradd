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
    
    func deleteProfile(
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        self.networkService.delete(
            url: "profile"
        ) {
            result in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func patchProfile(
        pictureUrl: String,
        firstName: String,
        lastName: String,
        completion: @escaping (Result<ProfileModel, Error>) -> Void
    ) {
        var body: [String: Any?] = [
            "first_name": nil,
            "last_name": nil,
            "picture_url": nil
        ]
        
        if !firstName.isEmpty {
            body["first_name"] = firstName
        }
        
        if !lastName.isEmpty {
            body["last_name"] = lastName
        }
        
        if !pictureUrl.isEmpty {
            body["picture_url"] = pictureUrl
        }
        
        self.networkService.patch(
            url: "profile",
            body: body
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
