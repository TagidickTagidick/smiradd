protocol IFavoritesRepository {
    func getFavorites(
        completion: @escaping (Result<FavoritesModel, ErrorModel>) -> Void
    )
}
