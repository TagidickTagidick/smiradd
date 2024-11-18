import SwiftUI
import CardStack

class CardViewModel: ObservableObject {
    @Published var pageType: PageType = .loading
    
    @Published var avatarImage: UIImage?
    @Published var avatarVideo: URL?
    @Published var avatarUrl: String = ""
    
    @Published var jobTitle: String = ""
    @Published var jobTitleIsFocused: Bool = false
    
    @Published var specificity: String = "Выберите отрасль"
    @Published var specificityIsFocused: Bool = false
    
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
    @Published var logoVideo: URL?
    @Published var logoUrl: String = ""
    
    @Published var bio: String = ""
    
    var isValidButton: Bool {
        return !self.jobTitle.isEmpty && !self.specificity.isEmpty && !self.name.isEmpty &&
        !self.phone.isEmpty &&
        (self.email.isEmpty ? true : self.isValidEmail)
    }
    
    @Published var isAlert: Bool = false
    
    @Published var isDeleteFromFavorites: Bool = false
    
    @Published var noCardsSheet: Bool = false
    
    let cardId: String
    
    var deleteFromFavoritesCardId: String = ""
    
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
            self.email = self.commonViewModel.profileModel?.email ?? ""
            self.name = (self.commonViewModel.profileModel?.first_name ?? "") + " " + (self.commonViewModel.profileModel?.last_name ?? "")
        }
        else {
            self.getCard()
        }
    }
    
    private func getSpecifity() {
        if !self.commonViewModel.specificities.isEmpty {
            self.pageType = .matchNotFound
            
            return
        }
        
        self.commonRepository.getSpecificities() {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let specificityModels):
                    self.commonViewModel.specificities = specificityModels
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
                
                self.pageType = .matchNotFound
            }
        }
    }
    
    func getCard() {
        self.pageType = .loading
        
        self.repository.getCard(cardId: self.cardId) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cardModel):
                    self.commonViewModel.cardModel = cardModel
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
        self.jobTitle = self.commonViewModel.cardModel.job_title
        self.specificity = self.commonViewModel.cardModel.specificity
        self.name = self.commonViewModel.cardModel.name ?? ""
        self.phone = self.commonViewModel.cardModel.phone == nil
        ? ""
        : CustomFormatter.formatPhoneNumber(self.commonViewModel.cardModel.phone!)
        self.email = self.commonViewModel.cardModel.email
        self.address = self.commonViewModel.cardModel.address ?? ""
        self.seek = self.commonViewModel.cardModel.seek ?? ""
        self.useful = self.commonViewModel.cardModel.useful ?? ""
        self.telegram = self.commonViewModel.cardModel.tg_url ?? "https://t.me/"
        self.vk = self.commonViewModel.cardModel.vk_url ?? "https://vk.com/"
        self.site = self.commonViewModel.cardModel.seek ?? ""
        self.cv = self.commonViewModel.cardModel.cv_url ?? ""
        self.bio = self.commonViewModel.cardModel.bio ?? ""
        self.avatarUrl = self.commonViewModel.cardModel.avatar_url ?? ""
        self.logoUrl = self.commonViewModel.cardModel.company_logo ?? ""
        if self.commonViewModel.services.isEmpty {
            self.commonViewModel.services = self.commonViewModel.cardModel.services ?? []
        }
        if self.commonViewModel.achievements.isEmpty {
            self.commonViewModel.achievements = self.commonViewModel.cardModel.achievements ?? []
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
        self.navigationService.navigate(
            to: .achievementScreen(
                index: index
            )
        )
    }
    /// SERVICES
    
    func openServices(index: Int) {
        self.navigationService.navigate(
            to: .serviceScreen(
                index: index
            )
        )
    }
    
    func openTemplates() {
        self.navigationService.navigate(
            to: .templatesScreen(
                isTeam: false
            )
        )
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
                    break
                case .failure(let error):
                    // Handle error
                    break
                }
            }
            
            self.pageType = .matchNotFound
            self.navigationService.navigateBack()
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
        if self.avatarImage != nil {
            self.commonRepository.uploadImage(image: self.avatarImage!) {
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
        else if self.avatarVideo != nil {
            self.commonRepository.uploadVideo(video: self.avatarVideo!) {
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
        else {
            self.uploadLogo()
        }
    }
    
    private func uploadLogo() {
        if self.logoImage != nil {
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
        else if self.logoVideo != nil {
            self.commonRepository.uploadVideo(video: logoVideo!) {
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
        else {
            self.uploadServiceCover(index: 0)
        }
    }
    
    private func uploadServiceCover(
        index: Int
    ) {
        if self.commonViewModel.services.count == index {
            self.saveCard()
            return
        }
        
        if self.commonViewModel.services[index].coverImage != nil {
            self.commonRepository.uploadImage(
                image: self.commonViewModel.services[index].coverImage!
            ) {
                [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let url):
                        self.commonViewModel.services[index].cover_url = url
                    case .failure(let error):
                        break
                    }
                    
                    self.uploadServiceCover(
                        index: index + 1
                    )
                }
            }
        }
        else if self.commonViewModel.services[index].coverVideo != nil {
            self.commonRepository.uploadVideo(
                video: self.commonViewModel.services[index].coverVideo!
            ) {
                [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let url):
                        self.commonViewModel.services[index].cover_url = url
                    case .failure(let error):
                        break
                    }
                    
                    self.uploadServiceCover(
                        index: index + 1
                    )
                }
            }
        }
        else {
            self.uploadServiceCover(index: index + 1)
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
                achievements: self.commonViewModel.achievements,
                services: self.commonViewModel.services,
                phone: self.phone,
                address: self.address,
                seek: self.seek,
                useful: self.useful,
                telegram: self.telegram,
                vk: self.vk,
                site: self.site,
                cv: self.cv,
                bio: self.bio,
                bcTemplateType: self.commonViewModel.cardModel.bc_template_type ?? "",
                avatarUrl: self.avatarUrl,
                logoUrl: self.logoUrl
            ) {
                [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let cardModel):
                        print("success")
                        self.pageType = .matchNotFound
                        
                        let index = self.commonViewModel.myCards.firstIndex(
                            where: {
                                $0.id == cardModel.id
                            }
                        )
                        
                        if index != nil {
                            self.commonViewModel.myCards[index!] = cardModel
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
                achievements: self.commonViewModel.achievements,
                services: self.commonViewModel.services,
                phone: self.phone,
                address: self.address,
                seek: self.seek,
                useful: self.useful,
                telegram: self.telegram,
                vk: self.vk,
                site: self.site,
                cv: self.cv,
                bio: self.bio,
                bcTemplateType: self.commonViewModel.cardModel.bc_template_type ?? "",
                avatarUrl: self.avatarUrl,
                logoUrl: self.logoUrl
            ) {
                [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let cardModel):
                        self.pageType = .matchNotFound
                        
                        self.commonViewModel.myCards.append(cardModel)
                        
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
    
    func changeCardType() {
        self.cardType = .editCard
        self.getSpecifity()
    }
    
    func openDeleteFromFavoritesAlert() {
        self.deleteFromFavoritesCardId = self.cardId
        self.isDeleteFromFavorites = true
    }
    
    func deleteFromFavorites() {
        self.isDeleteFromFavorites = false
        
        self.commonRepository.deleteFavorites(
            cardId: self.deleteFromFavoritesCardId
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.commonViewModel.favoritesModel!.items.removeAll(
                        where: { $0.id == self.deleteFromFavoritesCardId }
                    )
                    
                    if self.commonViewModel.favoritesModel!.items.isEmpty {
                        self.commonViewModel.favoritesPageType = .nothingHereFavorites
                    }
                    
                    self.navigationService.navigateBack()
                    
                    break
                case .failure(let error):
                    break
                }
            }
        }
    }
    
    func changeIsDefault(isDefault: Bool) {
        if !isDefault {
            self.repository.putDefault(
                cardId: self.cardId
            ) {
                _ in
                DispatchQueue.main.async {
                    withAnimation {
                        self.commonViewModel.showAlert(
                            isError: false,
                            text: "Вы сделали эту визитку основной"
                        )
                    }
                    self.commonViewModel.cardModel.is_default = true
                }
            }
        }
    }
}
