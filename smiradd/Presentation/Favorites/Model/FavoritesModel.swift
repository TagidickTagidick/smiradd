import SwiftUI

struct FavoritesModel: Codable {
    var items: [CardModel] = []
    let total: Int
    let page: Int
    let size: Int
    let pages: Int
}
