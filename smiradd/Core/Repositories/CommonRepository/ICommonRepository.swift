import SwiftUI

protocol ICommonRepository {
    func uploadImage(
        image: UIImage,
        completion: @escaping (Result<String, Error>) -> Void
    )
    
    func uploadVideo(
        video: URL,
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
        completion: @escaping (Result<DetailsModel, Error>) -> Void
    )
    
    func invite(
        url: String,
        completion: @escaping (Result<DetailsModel, Error>) -> Void
    )
    
    func deleteFavorites(
        cardId: String,
        completion: @escaping (Result<DetailsModel, Error>) -> Void
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
    
    func patchAroundme(
        id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func postFirebaseCreate(
        firebaseToken: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func getNotifications(
        completion: @escaping (Result<NotificationsModel, ErrorModel>) -> Void
    )
    
    func getAroundMeCards(
        specificity: [String],
        code: String,
        completion: @escaping (Result<[CardModel], Error>) -> Void
    )
    
    func getAroundMeTeams(
        specificity: [String],
        code: String,
        completion: @escaping (Result<[TeamModel], Error>) -> Void
    )
    
    func postClear(
        isTeam: Bool,
        completion: @escaping (Result<DetailsModel, Error>) -> Void
    )
}
