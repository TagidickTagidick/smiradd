import SwiftUI

struct ServiceModel: Codable, Identifiable {
    var id: String {name}
    let name: String
    let description: String
    let price: Int
    let coverUrl: String
}

struct AchievementModel: Codable, Identifiable {
    var id: String {name}
    let name: String
    let description: String
    let url: String
}

struct CardModel: Codable, Identifiable {
    let id: String
//    let like: Bool?
//    let is_default: Bool
    let job_title: String
    let specificity: String
    let phone: String?
    let email: String
    let address: String?
    let name: String
    let useful: String?
    let seek: String?
    let tg_url: String?
    let vk_url: String?
    let fb_url: String?
    let cv_url: String?
    let company_logo: String?
    let bio: String?
    let bc_template_type: String?
    let services: [ServiceModel]?
    let achievements: [AchievementModel]?
    let avatar_url: String?
    let like: Bool?
    
    static let mock: [CardModel] = []
}
