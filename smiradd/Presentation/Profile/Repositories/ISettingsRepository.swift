protocol ISettingsRepository {
    func patchResetPassword(
        password: String,
        completion: @escaping (Result<Void, ErrorModel>) -> Void
    )
    
    func postTickets(
        mainText: String,
        completion: @escaping (Error?) -> Void
    )
}
