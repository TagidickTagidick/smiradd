protocol INotificationsRepository {
    func patchNotification(
        id: String,
        accepted: Bool?,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
