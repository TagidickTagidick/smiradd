protocol INetworkingRepository {
    func getAroundMeCards(
        specificity: [String],
        code: String,
        completion: @escaping (Result<[CardModel], Error>) -> Void
    )
    
    func getAroundMeTeams(
        specificity: [String],
        code: String,
        completion: @escaping (Result<[TeamModel], Error>) -> Void
    )
    
    func postClear(
        isTeam: Bool,
        completion: @escaping (Result<DetailsModel, Error>) -> Void
    )
}
