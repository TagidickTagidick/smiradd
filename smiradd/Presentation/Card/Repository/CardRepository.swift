import Foundation
import SwiftUI

class CardRepository: ICardRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getCard(
        cardId: String,
        completion: @escaping (Result<CardModel, Error>) -> Void
    ) {
        self.networkService.get(
            url: "cards/\(cardId)"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(withJSONObject: response, options: [])
                    let cardModel = try JSONDecoder().decode(CardModel.self, from: data)
                    completion(.success(cardModel))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func deleteCard(
        cardId: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        self.networkService.delete(
            url: "cards/\(cardId)"
        ) { result in
            switch result {
            case .success(_):
                completion(.success(()))
                break
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
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
    ) {
        let achievementsDict = achievements.map {
            achievement in
            var achievementBody: [String: Any?] = [
                "name": achievement.id
            ]
            
            if achievement.description != nil {
                if !achievement.description!.isEmpty {
                    achievementBody["description"] = achievement.description
                }
            }
            
            if achievement.url != nil {
                if !achievement.url!.isEmpty {
                    achievementBody["url"] = achievement.url
                }
            }
            
            return achievementBody
        }
        
        let servicesDict = services.map {
            service in
            var serviceBody: [String: Any?] = [
                "name": service.name,
                "description": service.description
            ]
            
            if service.cover_url != nil {
                if !service.cover_url!.isEmpty {
                    serviceBody["cover_url"] = service.cover_url
                }
            }
            
            if service.price != nil {
                if service.price != 0 {
                    serviceBody["price"] = service.price
                }
            }
            
            return serviceBody
        }
        
        var body: [String: Any?] = [
            "job_title": jobTitle,
            "specificity": specificity,
            "name": name,
            "phone": "+" + phone,
            "achievements": achievementsDict,
            "services": servicesDict
        ]
        
        if !email.isEmpty {
            body["email"] = email
        }
        
        if !seek.isEmpty {
            body["seek"] = seek
        }
        
        if !useful.isEmpty {
            body["useful"] = useful
        }
        
        if !address.isEmpty {
            body["address"] = address
        }
        
        if telegram.count != 13 {
            body["tg_url"] = telegram
        }
        
        if vk.count != 15 {
            body["vk_url"] = vk
        }
        
        if !site.isEmpty {
            body["seek"] = site
        }
        
        if !cv.isEmpty {
            body["cv_url"] = cv
        }
        
        if !bio.isEmpty {
            body["bio"] = bio
        }
        
        if !bcTemplateType.isEmpty {
            body["bc_template_type"] = bcTemplateType
        }
        
        if !avatarUrl.isEmpty {
            body["avatar_url"] = avatarUrl
        }
        
        if !logoUrl.isEmpty {
            body["company_logo"] = logoUrl
        }
        
        self.networkService.post(
            url: "cards",
            body: body as [String : Any]
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(
                        withJSONObject: response,
                        options: []
                    )
                    let cardModel = try JSONDecoder().decode(CardModel.self, from: data)
                    completion(.success(cardModel))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
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
    ) {
        let achievementsDict = achievements.map {
            achievement in
            var achievementBody: [String: Any?] = [
                "name": achievement.id
            ]
            
            if achievement.description != nil {
                if !achievement.description!.isEmpty {
                    achievementBody["description"] = achievement.description
                }
            }
            
            if achievement.url != nil {
                if !achievement.url!.isEmpty {
                    achievementBody["url"] = achievement.url
                }
            }
            
            return achievementBody
        }
        
        let servicesDict = services.map {
            service in
            var serviceBody: [String: Any?] = [
                "name": service.name,
                "description": service.description
            ]
            
            if service.cover_url != nil {
                if !service.cover_url!.isEmpty {
                    serviceBody["cover_url"] = service.cover_url
                }
            }
            
            if service.price != nil {
                if service.price != 0 {
                    serviceBody["price"] = service.price
                }
            }
            
            return serviceBody
        }
        
        var body: [String: Any] = [
            "job_title": jobTitle,
            "specificity": specificity,
            "name": name,
            "phone": "+" + phone,
            "achievements": achievementsDict,
            "services": servicesDict
        ]
        
        if !email.isEmpty {
            body["email"] = email
        }
        
        if !seek.isEmpty {
            body["seek"] = seek
        }
        
        if !useful.isEmpty {
            body["useful"] = useful
        }
        
        if !address.isEmpty {
            body["address"] = address
        }
        
        if telegram.count != 13 {
            body["tg_url"] = telegram
        }
        
        if vk.count != 15 {
            body["vk_url"] = vk
        }
        
        if !site.isEmpty {
            body["seek"] = site
        }
        
        if !cv.isEmpty {
            body["cv_url"] = cv
        }
        
        if !bio.isEmpty {
            body["bio"] = bio
        }
        
        if !bcTemplateType.isEmpty {
            body["bc_template_type"] = bcTemplateType
        }
        
        if !avatarUrl.isEmpty {
            body["avatar_url"] = avatarUrl
        }
        
        if !logoUrl.isEmpty {
            body["company_logo"] = logoUrl
        }
        
        self.networkService.patch(
            url: "cards/\(cardId)",
            body: body
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(
                        withJSONObject: response,
                        options: []
                    )
                    let cardModel = try JSONDecoder().decode(CardModel.self, from: data)
                    completion(.success(cardModel))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func putDefault(
        cardId: String,
        completion: @escaping (Result<CardModel, Error>) -> Void
    ) {
        self.networkService.put(
            url: "cards/\(cardId)/default"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(
                        withJSONObject: response,
                        options: []
                    )
                    let cardModel = try JSONDecoder().decode(CardModel.self, from: data)
                    completion(.success(cardModel))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
}
