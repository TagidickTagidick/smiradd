import SwiftUI

struct CardModel: Codable, Identifiable {
    let id: String
//    let like: Bool?
//    let is_default: Bool
    let job_title: String
    var specificity: String
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
    var bc_template_type: String?
    let services: [ServiceModel]?
    let achievements: [AchievementModel]?
    var avatar_url: String?
    let like: Bool?
    
    static func makeMock(templateId: String) -> CardModel {
            return CardModel(
                id: "",
                job_title: "Арт-директор Ozon",
                specificity: "",
                phone: "7 (920) 121-50-44",
                email: "elemochka@klmn.com",
                address: nil,
                name: "Елена Грибоедова",
                useful: nil,
                seek: nil,
                tg_url: nil,
                vk_url: nil,
                fb_url: nil,
                cv_url: nil,
                company_logo: nil,
                bio: nil,
                bc_template_type: templateId,
                services: nil,
                achievements: nil,
                avatar_url: nil,
                like: false
            )
        }
    
    static let mocks: [CardModel] = []
    
    static let mock: CardModel = CardModel(
        id: "",
        job_title: "Арт-директор Ozon",
        specificity: "",
        phone: "7 (920) 121-50-44",
        email: "elemochka@klmn.com",
        address: nil,
        name: "Елена Грибоедова",
        useful: nil,
        seek: nil,
        tg_url: nil,
        vk_url: nil,
        fb_url: nil,
        cv_url: nil,
        company_logo: nil,
        bio: nil,
        bc_template_type: nil,
        services: nil,
        achievements: nil,
        avatar_url: nil,
        like: false
    )
}
