import SwiftUI

protocol ICardRepository {
    
    func getCard(
        cardId: String,
        completion: @escaping (Result<CardModel, Error>) -> Void
    )
    
    func deleteCard(
        cardId: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func postCard(
        jobTitle: String,
        specificity: String,
        name: String,
        email: String,
        achievements: [AchievementModel],
        services: [ServiceModel],
        phone: String,
        address: String,
        seek: String,
        useful: String,
        telegram: String,
        vk: String,
        site: String,
        cv: String,
        bio: String,
        bcTemplateType: String,
        avatarUrl: String,
        logoUrl: String,
        completion: @escaping (Result<CardModel, Error>) -> Void
    )
    
    func patchCard(
        cardId: String,
        jobTitle: String,
        specificity: String,
        name: String,
        email: String,
        achievements: [AchievementModel],
        services: [ServiceModel],
        phone: String,
        address: String,
        seek: String,
        useful: String,
        telegram: String,
        vk: String,
        site: String,
        cv: String,
        bio: String,
        bcTemplateType: String,
        avatarUrl: String,
        logoUrl: String,
        completion: @escaping (Result<CardModel, Error>) -> Void
    )
    
    func putDefault(
        cardId: String,
        completion: @escaping (Result<CardModel, Error>) -> Void
    )
}
