import SwiftUI

protocol ICommonRepository {
    func uploadImage(
        image: UIImage,
        completion: @escaping (Result<String, Error>) -> Void
    )
    
    func getSpecificities(
        completion: @escaping (Result<[SpecificityModel], Error>) -> Void
    )
    
    func getTemplates(
        completion: @escaping (Result<[TemplateModel], Error>) -> Void
    )
    
    func postMyLocation(
        latitude: Double,
        longitude: Double,
        code: String,
        completion: @escaping (Result<LocationModel, Error>) -> Void
    )
    
    func getCards(
        completion: @escaping (Result<[CardModel], Error>) -> Void
    )
    
    func postFavorites(
        cardId: String,
        completion: @escaping (Result<DetailModel, Error>) -> Void
    )
    
    func invite(
        url: String,
        completion: @escaping (Result<DetailModel, Error>) -> Void
    )
    
    func deleteFavorites(
        cardId: String,
        completion: @escaping (Result<DetailModel, Error>) -> Void
    )
    
    func getTeam(
        completion: @escaping (Result<TeamMainModel, Error>) -> Void
    )
    
    func postRequest(
        id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func postTeamInvite(
        id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func deleteTeam(
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func deleteLeaveTeam(
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
