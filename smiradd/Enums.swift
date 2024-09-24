enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum PageType {
    case loading
    case matchNotFound
    case pageNotFound
    case noResultsFound
    case somethingWentWrong
    case nothingHereProfile
    case nothingHereFavorites
    case nothingHereNotifications
    case shareLocation
}

enum CardType {
    case favoriteCard
    case userCard
    case myCard
    case editCard
    case newCard
}
