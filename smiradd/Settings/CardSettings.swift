import SwiftUI

class CardSettings: ObservableObject {
    @Published var cardId: String = ""
    @Published var cardType: CardType = .userCard
    @Published var cardModel: CardModel = CardModel(
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
    
    @Published var bcTemplateType = ""
    
    @Published var serviceIndex = -1
    @Published var services: [ServiceModel] = []
    
    @Published var achievementIndex = -1
    @Published var achievements: [AchievementModel] = []
}
