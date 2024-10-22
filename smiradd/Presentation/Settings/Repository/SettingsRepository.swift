import Foundation

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
}
