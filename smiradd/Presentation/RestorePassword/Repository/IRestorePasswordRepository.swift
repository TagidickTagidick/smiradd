protocol IRestorePasswordRepository {
    func postEmail(
        email: String,
        completion: @escaping (Result<DetailsModel, ErrorModel>) -> Void
    )
    
    func postCodeVerify(
        code: String,
        email: String,
        completion: @escaping (Result<DetailsModel, ErrorModel>) -> Void
    )
}

