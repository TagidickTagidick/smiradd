protocol ISettingsRepository {
    func postTickets(
        mainText: String,
        completion: @escaping (Error?) -> Void
    )
}
