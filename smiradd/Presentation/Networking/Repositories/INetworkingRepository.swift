protocol INetworkingRepository {
    func getAroundMe(completion: @escaping (Result<[CardModel], Error>) -> Void)
}
