import SwiftUI

protocol ICardRepository {
    func getSpecificities(completion: @escaping (Result<[SpecificityModel], Error>) -> Void)
    
    func getCard(
        cardId: String,
        completion: @escaping (Result<CardModel, Error>) -> Void
    )
    
    func getTemplates(completion: @escaping (Result<[TemplateModel], Error>) -> Void)
    
    func deleteCard(
        cardId: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func uploadImage(
        image: UIImage,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func postCard(
        cardId: String,
        jobTitle: String,
        specificity: String,
        firstName: String,
        lastName: String,
        email: String,
        achievements: [AchievementModel],
        services: [ServiceModel],
        phone: String,
        address: String,
        telegram: String,
        vk: String,
        facebook: String,
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
        firstName: String,
        lastName: String,
        email: String,
        achievements: [AchievementModel],
        services: [ServiceModel],
        phone: String,
        address: String,
        telegram: String,
        vk: String,
        facebook: String,
        site: String,
        cv: String,
        bio: String,
        bcTemplateType: String,
        avatarUrl: String,
        logoUrl: String,
        completion: @escaping (Result<CardModel, Error>) -> Void
    )
}
