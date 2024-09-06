protocol IAuthorizationRepository {
    func signUpWithEmail(email: String, password: String, completion: @escaping (Result<AuthorizationModel, Error>) -> Void)
    func signInWithEmail(email: String, password: String, completion: @escaping (Result<AuthorizationModel, ErrorModel>) -> Void)
    func signInWithGoogle(completion: @escaping (Result<Void, Error>) -> Void)
}
