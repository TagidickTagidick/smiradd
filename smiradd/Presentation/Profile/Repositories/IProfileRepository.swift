protocol IProfileRepository {
    func getProfile(
        completion: @escaping (Result<ProfileModel, Error>) -> Void
    )
}
