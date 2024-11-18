import Foundation

class TeamRepository: ITeamRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getMyTeam(
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
    
    func getTeam(
        id: String,
        completion: @escaping (Result<TeamMainModel, Error>) -> Void
    ) {
        self.networkService.get(
            url: "team/\(id)"
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
    
    func postTeam(
        name: String,
        aboutTeam: String,
        aboutProject: String,
        teamLogo: String,
        bcTemplateType: String,
        completion: @escaping (Result<TeamModel, ErrorModel>) -> Void
    ) {
        var body: [String: Any] = [
            "name": name,
            "about_team": "",
            "about_project": "",
            "team_logo": "",
            "bc_template_type": ""
        ]
        
        if !aboutTeam.isEmpty {
            body["about_team"] = aboutTeam
        }
        
        if !aboutProject.isEmpty {
            body["about_project"] = aboutProject
        }
        
        if !teamLogo.isEmpty {
            body["team_logo"] = teamLogo
        }
        
        if !bcTemplateType.isEmpty {
            body["bc_template_type"] = bcTemplateType
        }
        
        self.networkService.post(
            url: "team/create",
            body: body
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(
                        withJSONObject: response,
                        options: []
                    )
                    let teamModel = try JSONDecoder().decode(
                        TeamModel.self,
                        from: data
                    )
                    completion(.success(teamModel))
                } catch {
                    completion(.failure(ErrorModel(statusCode: 500, message: "")))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func putTeam(
        name: String,
        aboutTeam: String,
        aboutProject: String,
        teamLogo: String,
        inviteUrl: String,
        bcTemplateType: String,
        completion: @escaping (Result<TeamModel, Error>) -> Void
    ) {
        var body: [String: Any] = [
            "name": name,
            "about_team": "",
            "about_project": "",
            "team_logo": "",
            "invite_url": "",
            "bc_template_type": ""
        ]
        
        if !aboutTeam.isEmpty {
            body["about_team"] = aboutTeam
        }
        
        if !aboutProject.isEmpty {
            body["about_project"] = aboutProject
        }
        
        if !teamLogo.isEmpty {
            body["team_logo"] = teamLogo
        }
        
        if !bcTemplateType.isEmpty {
            body["bc_template_type"] = bcTemplateType
        }
        
        if !inviteUrl.isEmpty {
            body["invite_url"] = inviteUrl
        }
        
        self.networkService.put(
            url: "team",
            body: body
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(
                        withJSONObject: response,
                        options: []
                    )
                    let teamModel = try JSONDecoder().decode(
                        TeamModel.self,
                        from: data
                    )
                    completion(.success(teamModel))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func postKick(
        id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        self.networkService.post(
            url: "team/kick",
            body: ["teammate_id": id]
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
}
