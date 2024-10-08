import Foundation
class FavoritesRepository: IFavoritesRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getFavorites(
        completion: @escaping (Result<FavoritesModel, ErrorModel>) -> Void
    ) {
        self.networkService.get(
            url: "my/favorites"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(
                        withJSONObject: response,
                        options: []
                    )
                    let favoritesModel = try JSONDecoder().decode(
                        FavoritesModel.self,
                        from: data
                    )
                    
                    completion(.success(favoritesModel))
                } catch {
                    completion(
                        .failure(
                            ErrorModel(
                                statusCode: 500,
                                message: "Invalid json"
                            )
                        )
                    )
                }
            case .failure(let errorModel):
                completion(.failure(errorModel))
            }
        }
    }
}
