class MockNetworkRepository: INetworkingRepository {
    func patchAroundme(id: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        
    }
    
    func getAroundMeCards(
        specificity: [String],
        code: String, completion: @escaping (Result<[CardModel], any Error>) -> Void) {
        
    }
    
    func getAroundMeTeams(specificity: [String], code: String, completion: @escaping (Result<[TeamModel], any Error>) -> Void) {
        
    }
    
    func postClear(
        isTeam: Bool, completion: @escaping (Result<DetailsModel, any Error>) -> Void) {
        
    }
    
    func getAroundMe(
        specificity: [String],
        code: String,
        isTeam: Bool,
        completion: @escaping (Result<[CardModel], Error>) -> Void
    ) {
        completion(.success(
            [
                CardModel(
                    id: "1",
                    job_title: "Арт-директор Ozon",
                    specificity: "sjsjjs",
                    phone: "+79969267921",
                    email: "tagidick.tagidick@gmail.com",
                    address: "ыорырры",
                    name: "Елена Грибанова",
                    useful: "true",
                    seek: "выыв",
                    tg_url: "ырырры",
                    vk_url: "ырыррыр",
                    fb_url: "ырырры",
                    cv_url: "ырырры",
                    company_logo: "ыооыоы",
                    bio: "Я учусь в четвертом классе средней школы №53. Учусь хорошо, я – твердый отличник. Я живу в Москве со своей семьей. Она у меня небольшая и состоит из четырех человек: мама, папа, старшая сестра и я. У нас очень дружная семья",
                    bc_template_type: "ыррыр",
                    services: [],
                    achievements: [],
                    avatar_url: nil,
                    like: false
                )
            ]
        )
        )
    }
    
    func postFavorites(
        cardId: String,
        completion: @escaping (Result<DetailsModel, Error>) -> Void
    ) {
        
    }
    
    func deleteFavorites(
        cardId: String,
        completion: @escaping (Result<DetailsModel, Error>) -> Void
    ) {
        
    }
}
