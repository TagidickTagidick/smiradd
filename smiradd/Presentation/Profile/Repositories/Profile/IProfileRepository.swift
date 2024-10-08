protocol IProfileRepository {
    func getProfile(
        completion: @escaping (Result<ProfileModel, Error>) -> Void
    )
    
    func getNotifications(
        completion: @escaping (Result<NotificationsModel, ErrorModel>) -> Void
    )
    
    func deleteProfile(
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func patchProfile(
        pictureUrl: String,
        firstName: String,
        lastName: String,
        completion: @escaping (Result<ProfileModel, Error>) -> Void
    )
    
    func patchNotification(
        id: String,
        accepted: Bool?,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
