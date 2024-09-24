protocol ISettingsRepository {
    func patchProfile(
        pictureUrl: String?,
        firstName: String,
        lastName: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
