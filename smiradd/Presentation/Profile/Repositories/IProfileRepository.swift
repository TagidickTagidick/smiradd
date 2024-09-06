protocol IProfileRepository {
    func getProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void)
    func getCards(completion: @escaping (Result<[CardModel], Error>) -> Void)
    func getNotifications(completion: @escaping (Result<NotificationsModel, Error>) -> Void)
}
