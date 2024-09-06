import SwiftUI

struct ServiceModel: Codable, Identifiable {
    var id: String {name}
    let name: String
    let description: String
    let price: Int
    let coverUrl: String
}

struct ServiceModelLocal: Identifiable {
    var id: String {name}
    let name: String
    let description: String
    let price: Int
    let coverUrl: String
    let cover: UIImage?
}
