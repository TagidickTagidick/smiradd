protocol IFavoritesRepository {
    func getFavorites(
        completion: @escaping (Result<FavoritesModel, Error>) -> Void
    )
}
