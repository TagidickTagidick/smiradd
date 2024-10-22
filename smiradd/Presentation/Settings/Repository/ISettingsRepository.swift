protocol ISettingsRepository {
    func patchResetPassword(
        password: String,
        completion: @escaping (Result<Void, ErrorModel>) -> Void
    )
    
    func postTickets(
        mainText: String,
        completion: @escaping (Error?) -> Void
    )
    
    func patchProfile(
        pictureUrl: String,
        firstName: String,
        lastName: String,
        completion: @escaping (Result<ProfileModel, Error>) -> Void
    )
    
    func deleteProfile(
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
