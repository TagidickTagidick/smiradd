protocol INetworkingRepository {
    func postClear(
        isTeam: Bool,
        completion: @escaping (Result<DetailsModel, Error>) -> Void
    )
}
