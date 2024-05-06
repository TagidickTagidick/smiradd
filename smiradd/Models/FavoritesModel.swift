import SwiftUI

struct FavoritesModel: Codable {
    let items: [CardModel]
    let total: Int
    let page: Int
    let size: Int
    let pages: Int
}
