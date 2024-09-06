import Foundation
import SwiftUI

class CardRepository: ICardRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getSpecificities(completion: @escaping (Result<[SpecificityModel], Error>) -> Void) {
        self.networkService.get(
            url: "specifity"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(withJSONObject: response["payload"] ?? [], options: [])
                    let specificityModels = try JSONDecoder().decode([SpecificityModel].self, from: data)
                    completion(.success(specificityModels))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func getCard(cardId: String, completion: @escaping (Result<CardModel, Error>) -> Void) {
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
    
    func getTemplates(completion: @escaping (Result<[TemplateModel], Error>) -> Void) {
        self.networkService.get(
            url: "templates"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(withJSONObject: response["payload"] ?? [], options: [])
                    let templateModels = try JSONDecoder().decode([TemplateModel].self, from: data)
                    completion(.success(templateModels))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func deleteCard(cardId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.networkService.delete(
            url: "cards/\(cardId)"
        ) { result in
            switch result {
            case .success(let response):
                print("success")
                break
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
    func uploadImage(image: UIImage, completion: @escaping (Result<DetailsModel, Error>) -> Void) {
        self.networkService.uploadImage(
            image: image
        ) { result in
            switch result {
            case .success(let response):
                break
            case .failure(let errorModel):
                print("Signup failed: \(errorModel.message)")
                completion(.failure(errorModel))
            }
        }
    }
    
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
    ) {
        let achievementsDict = self.achievements.map { achievement in
            return [
                "id": achievement.id,
                "name": achievement.name,
                "description": achievement.description,
                "url": achievement.url
            ]
        }
        
        let servicesDict = cardSettings.services.map { service in
            return [
                "name": service.name,
                "description": service.description,
                "price": service.price,
                "cover_url": service.coverUrl
            ]
        }
        
        var body: [String: Any?] = [
            "job_title": jobTitle,
            "specificity": specificity,
            "name": firstName + " " + lastName,
            "email": email,
            "achievements": achievementsDict,
            "services": servicesDict
        ]
        
        if !phone.isEmpty {
            body["phone"] = "+" + phone
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
        
        if facebook.count != 25 {
            body["fb_url"] = facebook
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
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        self.networkService.post(
            url: "cards/\(cardId)",
            body: finalBody
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(withJSONObject: response["payload"] ?? [], options: [])
                    let templateModels = try JSONDecoder().decode(CardModel.self, from: data)
                    completion(.success(templateModels))
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
    ) {
        let achievementsDict = self.achievements.map { achievement in
            return [
                "id": achievement.id,
                "name": achievement.name,
                "description": achievement.description,
                "url": achievement.url
            ]
        }
        
        let servicesDict = cardSettings.services.map { service in
            return [
                "name": service.name,
                "description": service.description,
                "price": service.price,
                "cover_url": service.coverUrl
            ]
        }
        
        var body: [String: Any?] = [
            "job_title": jobTitle,
            "specificity": specificity,
            "name": firstName + " " + lastName,
            "email": email,
            "achievements": achievementsDict,
            "services": servicesDict
        ]
        
        if !phone.isEmpty {
            body["phone"] = "+" + phone
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
        
        if facebook.count != 25 {
            body["fb_url"] = facebook
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
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        self.networkService.patch(
            url: "cards/\(cardId)",
            body: finalBody
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONSerialization.data(withJSONObject: response["payload"] ?? [], options: [])
                    let templateModels = try JSONDecoder().decode(CardModel.self, from: data)
                    completion(.success(templateModels))
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
