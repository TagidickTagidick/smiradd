protocol ITeamRepository {
    func getMyTeam(
        completion: @escaping (Result<TeamMainModel, Error>) -> Void
    )
    
    func getTeam(
        id: String,
        completion: @escaping (Result<TeamMainModel, Error>) -> Void
    )
    
    func postTeam(
        name: String,
        aboutTeam: String,
        aboutProject: String,
        teamLogo: String,
        bcTemplateType: String,
        completion: @escaping (Result<TeamModel, ErrorModel>) -> Void
    )
    
    func putTeam(
        name: String,
        aboutTeam: String,
        aboutProject: String,
        teamLogo: String,
        inviteUrl: String,
        bcTemplateType: String,
        completion: @escaping (Result<TeamModel, Error>) -> Void
    )
    
    func postKick(
        id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
