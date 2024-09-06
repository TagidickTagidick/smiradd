import SwiftUI

class CardViewModel: ObservableObject {
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
    
    @Published var pageType: PageType = .loading
    
    @Published var bcTemplateType = ""
    
    @Published var achievementIndex = -1
    @Published var achievements: [AchievementModel] = []
    
    @Published var avatarImage: UIImage?
    @Published var avatarUrl: String?
    
    @Published var jobTitle: String = ""
    @Published var jobTitleIsFocused: Bool = false
    
    @Published var specificity: String = ""
    @Published var specificityIsFocused: Bool = false
    @Published var specificityList: [SpecificityModel] = []
    
    @Published var firstName: String = ""
    
    @Published var lastName: String = ""
    
    @Published var oldPhone: String = ""
    @Published var phone: String = ""
    
    @Published var email: String = ""
    
    @Published var address: String = ""
    
    @Published var telegram: String = "https://t.me/"
    
    @Published var vk: String = "https://vk.com/"
    
    @Published var facebook: String = "https://www.facebook.com/"
    
    @Published var site: String = ""
    
    @Published var cv: String = ""
    
    @Published var logoImage: UIImage?
    @Published var logoUrl: String?
    
    @Published var bio: String = ""
    
    @Published var templatesOpened: Bool = false
    @Published var templatesPageType: PageType = .loading
    @Published var templates: [TemplateModel] = []
    
    @Published var servicesOpened: Bool = false
    @Published var serviceIndex = -1
    @Published var services: [ServiceModelLocal] = []
    
    let cardId: String
    
    var cardType: CardType
    
    private let repository: ICardRepository
    
    private let navigationService: NavigationService
    
    init(
        repository: ICardRepository,
        navigationService: NavigationService,
        cardId: String,
        cardType: CardType
    ) {
        self.repository = repository
        self.navigationService = navigationService
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
        self.repository.getSpecificities() {
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
                self.pageType = .matchNotFound
                switch result {
                case .success(let cardModel):
                    self.cardModel = cardModel
                    self.initFields()
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
            }
        }
    }
    
    private func initFields() {
        if self.cardType != .editCard {
            return
        }
        
        self.jobTitle = self.cardModel.job_title
        self.specificity = self.cardModel.specificity
        self.firstName = self.cardModel.name.split(separator: " ").first!.description
        self.lastName = self.cardModel.name.split(separator: " ").last!.description
        self.phone = self.cardModel.phone == nil
        ? ""
        : CustomFormatter.formatPhoneNumber(cardSettings.cardModel.phone!)
        self.email = self.cardModel.email
        self.address = self.cardModel.address ?? ""
        self.telegram = self.cardModel.tg_url ?? "https://t.me/"
        self.vk = self.cardModel.vk_url ?? "https://vk.com/"
        self.facebook = self.cardModel.fb_url ?? "https://www.facebook.com/"
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
    
    func onChangeFacebook() {
        if self.facebook.count < 25 {
            self.facebook = "https://www.facebook.com/"
        }
    }
    
    func openTemplates() {
        self.templatesPageType = .loading
        self.templatesOpened = true
        self.getTemplates()
    }
    
    private func getTemplates() {
        self.repository.getTemplates() {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let templateModels):
                    self.templates = templateModels
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
                self.templatesPageType = .matchNotFound
            }
        }
    }
    
    func closeTemplates(currentIndex: Int) {
        self.templatesOpened = false
        
        if (currentIndex == -1) {
            return
        }
        
        self.bcTemplateType = self.templates[currentIndex].id
    }
    
    
    /// SERVICES
    
    func openServices(serviceIndex: Int) {
        self.serviceIndex = serviceIndex
        self.servicesOpened = true
    }
    
    func saveService(image: UIImage?, imageUrl: String, name: String, description: String, price: String) {
        if name.isEmpty || description.isEmpty {
            return
        }
        
        if serviceIndex == -1 {
            services.append(
                ServiceModelLocal(
                    name: name,
                    description: description,
                    price: Int(price) ?? 0,
                    coverUrl: imageUrl,
                    cover: image
                )
            )
        }
        else {
            services.insert(
                ServiceModelLocal(
                    name: name,
                    description: description,
                    price: Int(price) ?? 0,
                    coverUrl: imageUrl,
                    cover: image
                ),
                at: serviceIndex
            )
        }
        
        servicesOpened = false
    }
    
    func deleteService() {
        self.services.remove(at: serviceIndex)
        self.closeServices()
    }
    
    func closeServices() {
        self.servicesOpened = false
    }
    
    func deleteCard() {
        self.repository.deleteCard(cardId: self.cardId) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let templateModels):
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
                self.templatesPageType = .matchNotFound
            }
        }
    }
    
    func save() {
        if self.jobTitle.isEmpty || self.specificity.isEmpty || self.firstName.isEmpty || self.lastName.isEmpty || self.email.isEmpty {
            return
        }
        
        self.uploadAvatar()
    }
    
    private func uploadAvatar() {
        if (avatarImage == nil) {
            self.uploadLogo()
        }
        
        self.repository.uploadImage(image: avatarImage!) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detailsModel):
                    self.avatarUrl = "https://s3.timeweb.cloud/29ad2e34-vizme/\(detailsModel.details)"
                    self.uploadLogo()
                case .failure(let error):
                    // Handle error
                    break
                }
                self.templatesPageType = .matchNotFound
            }
        }
    }
    
    private func uploadLogo() {
        if (logoImage == nil) {
            self.saveCard()
        }
        
        self.repository.uploadImage(image: logoImage!) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detailsModel):
                    self.logoUrl = "https://s3.timeweb.cloud/29ad2e34-vizme/\(detailsModel.details)"
                    self.saveCard()
                case .failure(let error):
                    // Handle error
                    break
                }
                self.templatesPageType = .matchNotFound
            }
        }
    }
    
    private func saveCard() {
        if self.cardType == .editCard {
            self.repository.patchCard(
                cardId: self.cardId,
                jobTitle: self.jobTitle,
                specificity: self.specificity,
                firstName: self.firstName,
                lastName: self.lastName,
                email: self.email,
                achievements: self.achievements,
                services: self.services,
                phone: self.phone,
                address: self.address,
                telegram: self.telegram,
                vk: self.vk,
                facebook: self.facebook,
                site: self.site,
                cv: self.cv,
                bio: self.bio,
                bcTemplateType: self.bcTemplateType,
                avatarUrl: self.avatarUrl,
                logoUrl: self.logoUrl,
            ) {
                [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let detailsModel):
                        
                    case .failure(let error):
                        // Handle error
                        break
                    }
                }
            }
        }
        else {
            self.repository.postCard(
                cardId: self.cardId,
                jobTitle: self.jobTitle,
                specificity: self.specificity,
                firstName: self.firstName,
                lastName: self.lastName,
                email: self.email,
                achievements: self.achievements,
                services: self.services,
                phone: self.phone,
                address: self.address,
                telegram: self.telegram,
                vk: self.vk,
                facebook: self.facebook,
                site: self.site,
                cv: self.cv,
                bio: self.bio,
                bcTemplateType: self.bcTemplateType,
                avatarUrl: self.avatarUrl,
                logoUrl: self.logoUrl,
            ) {
                [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let detailsModel):
                        
                    case .failure(let error):
                        // Handle error
                        break
                    }
                }
            }
        }
    }
}
