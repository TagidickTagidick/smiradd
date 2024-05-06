import SwiftUI

class FavoritesSettings: ObservableObject {
    @Published var favoritesModel: FavoritesModel?
    @Published var mySpecificities: [String] = []
}
