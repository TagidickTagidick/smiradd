protocol INetworkClient {
    func post(url: String, body: [String: Any], completion: @escaping (Result<[String: Any], ErrorModel>) -> Void)
    func get(url: String, completion: @escaping (Result<[String: Any], ErrorModel>) -> Void)
    func delete(url: String, completion: @escaping (Result<[String: Any], ErrorModel>) -> Void)
    func patch(url: String, body: [String: Any], completion: @escaping (Result<[String: Any], ErrorModel>) -> Void)
    func refresh(completion: @escaping (Result<Void, ErrorModel>) -> Void)
}
