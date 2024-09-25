import SwiftUI

class CardViewModel: ObservableObject {
    @Published var cardModel: CardModel = CardModel.mock
    
    @Published var pageType: PageType = .loading
    
    @Published var achievementsOpened: Bool = false
    @Published var achievementIndex = -1
    @Published var achievements: [AchievementModel] = []
    
    @Published var avatarImage: UIImage?
    @Published var avatarUrl: String = ""
    
    @Published var jobTitle: String = ""
    @Published var jobTitleIsFocused: Bool = false
    
    @Published var specificity: String = ""
    @Published var specificityIsFocused: Bool = false
    @Published var specificityList: [SpecificityModel] = []
    
    @Published var name: String = ""
    
    @Published var oldPhone: String = ""
    @Published var phone: String = ""
    
    @Published var email: String = ""
    @Published var isValidEmail: Bool = true
    
    @Published var address: String = ""
    
    @Published var seek: String = ""
    
    @Published var useful: String = ""
    
    @Published var telegram: String = "https://t.me/"
    
    @Published var vk: String = "https://vk.com/"
    
    @Published var site: String = ""
    
    @Published var cv: String = ""
    
    @Published var logoImage: UIImage?
    @Published var logoUrl: String = ""
    
    @Published var bio: String = ""
    
    @Published var templatesOpened: Bool = false
    
    @Published var servicesOpened: Bool = false
    @Published var serviceIndex = -1
    @Published var services: [ServiceModel] = []
    
    var isValidButton: Bool {
        return !self.jobTitle.isEmpty && !self.specificity.isEmpty && !self.name.isEmpty &&
        !self.phone.isEmpty &&
        (self.email.isEmpty ? true : self.isValidEmail)
    }
    
    @Published var isAlert: Bool = false
    
    @Published var noCardsSheet: Bool = false
    
    let cardId: String
    
    @Published var cardType: CardType
    
    private let repository: ICardRepository
    private let commonRepository: ICommonRepository
    private let navigationService: NavigationService
    private let commonViewModel: CommonViewModel
    
    init(
        repository: ICardRepository,
        commonRepository: ICommonRepository,
        navigationService: NavigationService,
        commonViewModel: CommonViewModel,
        cardId: String,
        cardType: CardType
    ) {
        self.repository = repository
        self.commonRepository = commonRepository
        self.navigationService = navigationService
        self.commonViewModel = commonViewModel
        self.cardId = cardId
        self.cardType = cardType
        if self.cardType == .newCard {
            self.getSpecifity()
        }
        else {
            self.getCard(cardId: cardId)
        }
    }
    
    private func getSpecifity() {
        self.commonRepository.getSpecificities() {
            [self] result in
            DispatchQueue.main.async {
                self.pageType = .matchNotFound
                switch result {
                case .success(let specificityModels):
                    self.specificityList = specificityModels
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
            }
        }
    }
    
    private func getCard(cardId: String) {
        self.repository.getCard(cardId: cardId) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cardModel):
                    self.cardModel = cardModel
                    self.initFields()
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
                
                self.pageType = .matchNotFound
            }
        }
    }
    
    private func initFields() {
        self.jobTitle = self.cardModel.job_title
        self.specificity = self.cardModel.specificity
        self.name = self.cardModel.name ?? ""
        self.phone = self.cardModel.phone == nil
        ? ""
        : CustomFormatter.formatPhoneNumber(self.cardModel.phone!)
        self.email = self.cardModel.email
        self.address = self.cardModel.address ?? ""
        self.seek = self.cardModel.seek ?? ""
        self.useful = self.cardModel.useful ?? ""
        self.telegram = self.cardModel.tg_url ?? "https://t.me/"
        self.vk = self.cardModel.vk_url ?? "https://vk.com/"
        self.site = self.cardModel.seek ?? ""
        self.cv = self.cardModel.cv_url ?? ""
        self.bio = self.cardModel.bio ?? ""
        self.avatarUrl = self.cardModel.avatar_url ?? ""
        if self.services.isEmpty {
            self.services = self.cardModel.services ?? []
        }
        if self.achievements.isEmpty {
            self.achievements = self.cardModel.achievements ?? []
        }
    }
    
    func checkEmail() {
        let regex = try! NSRegularExpression(
            pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$",
            options: [.caseInsensitive]
        )
        self.isValidEmail = regex.firstMatch(
            in: self.email,
            options: [],
            range: NSRange(
                location: 0,
                length: self.email.utf16.count
            )
        ) != nil
    }
    
    func onChangePhone() {
        if self.oldPhone.count < self.phone.count {
            if self.oldPhone.count == 1 {
                let indexToAdd = self.phone.index(
                    before: self.phone.index(
                        self.phone.endIndex,
                        offsetBy: 0
                    )
                )
                self.phone.insert(contentsOf: " (", at: indexToAdd)
            }
            if self.oldPhone.count == 6 {
                let indexToAdd = self.phone.index(
                    before: self.phone.index(
                        self.phone.endIndex,
                        offsetBy: 0
                    )
                )
                self.phone.insert(contentsOf: ") ", at: indexToAdd)
            }
            if self.oldPhone.count == 11 || self.phone.count == 15 {
                let indexToAdd = self.phone.index(
                    before: self.phone.index(
                        self.phone.endIndex,
                        offsetBy: 0
                    )
                )
                self.phone.insert(contentsOf: "-", at: indexToAdd)
            }
        }
        else {
            if self.phone.count == 15 || self.phone.count == 12 {
                self.phone.removeLast()
            }
            if self.phone.count == 8 || self.phone.count == 3 {
                self.phone.removeLast()
                self.phone.removeLast()
            }
        }
        self.oldPhone = self.phone
    }
    
    func onChangeTelegram() {
        if self.telegram.count < 13 {
            self.telegram = "https://t.me/"
        }
    }
    
    func onChangeVk() {
        if self.vk.count < 15 {
            self.vk = "https://vk.com/"
        }
    }
    
    func openAchivement(index: Int) {
        self.achievementIndex = index
        self.achievementsOpened = true
    }
    
    func closeAchievement() {
        self.achievementsOpened = false
    }
    
    func openTemplates() {
        self.templatesOpened = true
    }
    
    func closeTemplates(id: String) {
        self.templatesOpened = false
        
        if (id.isEmpty) {
            return
        }
        
        self.cardModel.bc_template_type = id
    }
    
    
    /// SERVICES
    
    func openServices(serviceIndex: Int) {
        self.serviceIndex = serviceIndex
        self.servicesOpened = true
    }
    
    func saveService(
        image: UIImage?,
        imageUrl: String,
        name: String,
        description: String,
        price: String
    ) {
        if name.isEmpty || description.isEmpty {
            return
        }
        
        print(serviceIndex)
        
        if self.serviceIndex == -1 {
            self.services.append(
                ServiceModel(
                    name: name,
                    description: description,
                    price: Int(price) ?? 0,
                    cover_url: imageUrl,
                    cover: image
                )
            )
        }
        else {
            self.services[self.serviceIndex] = ServiceModel(
                name: name,
                description: description,
                price: Int(price) ?? 0,
                cover_url: imageUrl,
                cover: image
            )
        }
        
        self.closeServices()
    }
    
    func deleteService() {
        self.closeServices()
        self.services.remove(at: serviceIndex)
    }
    
    func closeServices() {
        self.servicesOpened = false
    }
    
    func deleteAchievement() {
        self.closeAchievement()
        self.achievements.remove(at: self.achievementIndex)
    }
    
    func saveAchievement(
        name: String,
        description: String,
        url: String
    ) {
        if name.isEmpty {
            return
        }
        
        if self.achievementIndex == -1 {
            self.achievements.append(
                AchievementModel(
                name: name,
                description: description,
                url: url
            )
            )
        }
        else {
            self.achievements[self.achievementIndex] = AchievementModel(
                name: name,
                description: description,
                url: url
                )
        }
        
        self.achievementsOpened = false
    }
    
    func openAlert() {
        self.isAlert = true
    }
    
    func closeAlert() {
        self.isAlert = false
    }
    
    func deleteCard() {
        self.pageType = .loading
        
        self.repository.deleteCard(cardId: self.cardId) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.pageType = .matchNotFound
                    self.navigationService.navigate(to: .profileScreen)
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
            }
        }
    }
    
    func startSave() {
        if self.isValidEmail {
            self.checkEmail()
        }
        
        if !self.isValidButton {
            return
        }
        
        self.pageType = .loading
        
        self.uploadAvatar()
    }
    
    private func uploadAvatar() {
        if (avatarImage == nil) {
            self.uploadLogo()
            
            return
        }
        
        self.commonRepository.uploadImage(image: avatarImage!) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    self.avatarUrl = url
                    self.uploadLogo()
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    }
    
    private func uploadLogo() {
        if (logoImage == nil) {
            self.uploadServiceCover(index: 0)
            
            return
        }
        
        self.commonRepository.uploadImage(image: logoImage!) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    self.logoUrl = url
                    self.uploadServiceCover(index: 0)
                case .failure(let error):
                    // Handle error
                    break
                }
            }
        }
    }
    
    private func uploadServiceCover(
        index: Int
    ) {
        if self.services.count == index {
            self.saveCard()
            return
        }
        
        if self.services[index].cover == nil {
            self.uploadServiceCover(index: index + 1)
            return
        }
        
        self.commonRepository.uploadImage(
            image: self.services[index].cover!
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    self.services[index].cover_url = url
                case .failure(let error):
                    break
                }
                
                self.uploadServiceCover(
                    index: index + 1
                )
            }
        }
    }
    
    func like() {
        if self.commonViewModel.cards.isEmpty {
            self.noCardsSheet = true
            return
        }
        
        self.commonRepository.postFavorites(
            cardId: self.cardId
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.navigationService.navigateBack()
                    
                    if self.commonViewModel.isTeamStorage {
                        self.commonViewModel.teamsCount -= 1
                        
                        self.commonViewModel.teamViews.removeFirst()
                        
//                        if self.commonViewModel.teamsCount == 1 {
//                            self.getAroundMe()
//                        }
                    }
                    else {
                        self.commonViewModel.cardsCount -= 1
                        
                        self.commonViewModel.cardViews.removeFirst()
                        
//                        if self.commonViewModel.cardsCount == 1 {
//                            self.getAroundMe()
//                        }
                    }
                    
                    break
                case .failure(let error):
                    break
                }
            }
        }
    }
    
    func dislike() {
        self.commonRepository.patchAroundme(
            id: self.cardId
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.navigationService.navigateBack()
                    
                    if self.commonViewModel.isTeamStorage {
                        self.commonViewModel.teamsCount -= 1
                        
                        self.commonViewModel.teamViews.removeFirst()
                        
//                        if self.commonViewModel.teamsCount == 1 {
//                            self.getAroundMe()
//                        }
                    }
                    else {
                        self.commonViewModel.cardsCount -= 1
                        
                        self.commonViewModel.cardViews.removeFirst()
                        
//                        if self.commonViewModel.cardsCount == 1 {
//                            self.getAroundMe()
//                        }
                    }
                    break
                case .failure(let error):
                    break
                }
            }
        }
    }
    
    func createCard() {
        self.noCardsSheet = false
        
        self.navigationService.navigateBack()
        
        self.navigationService.navigate(
            to: .profileScreen
        )
        
        self.navigationService.navigate(
            to: .cardScreen(
                cardId: "",
                cardType: .newCard
            )
        )
    }
        
    private func saveCard() {
            if self.cardType == .editCard {
                self.repository.patchCard(
                    cardId: self.cardId,
                    jobTitle: self.jobTitle,
                    specificity: self.specificity,
                    name: self.name,
                    email: self.email,
                    achievements: self.achievements,
                    services: self.services,
                    phone: self.phone,
                    address: self.address,
                    seek: self.seek,
                    useful: self.useful,
                    telegram: self.telegram,
                    vk: self.vk,
                    site: self.site,
                    cv: self.cv,
                    bio: self.bio,
                    bcTemplateType: self.cardModel.bc_template_type ?? "",
                    avatarUrl: self.avatarUrl,
                    logoUrl: self.logoUrl
                ) {
                    [self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let cardModel):
                            print("success")
                            self.pageType = .matchNotFound
                            
                            let index = self.commonViewModel.cards.firstIndex(
                                where: {
                                    $0.id == cardModel.id
                                }
                            )
                            
                            if index != nil {
                                self.commonViewModel.cards[index!] = cardModel
                            }
                            
                            self.navigationService.navigateBack()
                            
                            break
                        case .failure(let error):
                            print(error)
                            break
                        }
                    }
                }
            }
            else {
                self.repository.postCard(
                    jobTitle: self.jobTitle,
                    specificity: self.specificity,
                    name: self.name,
                    email: self.email,
                    achievements: self.achievements,
                    services: self.services,
                    phone: self.phone,
                    address: self.address,
                    seek: self.seek,
                    useful: self.useful,
                    telegram: self.telegram,
                    vk: self.vk,
                    site: self.site,
                    cv: self.cv,
                    bio: self.bio,
                    bcTemplateType: self.cardModel.bc_template_type ?? "",
                    avatarUrl: self.avatarUrl,
                    logoUrl: self.logoUrl
                ) {
                    [self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let cardModel):
                            self.pageType = .matchNotFound
                            
                            self.commonViewModel.cards.append(cardModel)
                            
                            self.navigationService.navigateBack()
                            
                            break
                        case .failure(let error):
                            // Handle error
                            break
                        }
                    }
                }
            }
        }
    }
