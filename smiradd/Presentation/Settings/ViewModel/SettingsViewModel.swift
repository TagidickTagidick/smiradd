import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var pageType: PageType = .matchNotFound
    
    @Published var pictureUrl: String = ""
    @Published var pictureImage: UIImage?
    @Published var pictureVideo: URL?
    
    @Published var firstName: String = ""
    
    @Published var lastName: String = ""
    
    @Published var password: String = ""
    @Published var isChangePassword: Bool = false
    
    @Published var isHelp: Bool = false
    
    @Published var isExit: Bool = false
    
    @Published var isDelete: Bool = false
    
    private let repository: ISettingsRepository
    private let commonRepository: ICommonRepository
    private var commonViewModel: CommonViewModel
    private let navigationService: NavigationService
    
    init(
        repository: ISettingsRepository,
        navigationService: NavigationService,
        commonViewModel: CommonViewModel,
        commonRepository: CommonRepository
    ) {
        self.repository = repository
        self.navigationService = navigationService
        self.commonViewModel = commonViewModel
        self.firstName = self.commonViewModel.profileModel?.first_name ?? ""
        self.lastName = self.commonViewModel.profileModel?.last_name ?? ""
        self.pictureUrl = self.commonViewModel.profileModel?.picture_url ?? ""
        self.commonRepository = commonRepository
    }
    
    func openChangePasswordSheet() {
        self.isChangePassword = true
    }
    
    func changePassword() {
        self.repository.patchResetPassword(
            password: self.password
        ) {
            result in
            DispatchQueue.main.async {
                self.password = ""
                self.isChangePassword = false
            }
        }
    }
    
    func closeChangePasswordSheet() {
        self.isChangePassword = false
    }
    
    func openHelpAlert() {
        self.isHelp = true
    }
    
    func closeHelpAlert() {
        self.isHelp = false
    }
    
    func openExitAlert() {
        self.isExit = true
    }
    
    func exitAccount() {
        UserDefaults.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.removeObject(forKey: "refresh_token")
        //self.navigationService.navigateToRoot()
        //self.navigationService.navigate(to: .signInScreen)
    }
    
    func closeExitAlert() {
        self.isExit = false
    }
    
    func openDeleteAlert() {
        self.isDelete = true
    }
    
    func closeDeleteAlert() {
        self.isDelete = false
    }
    
    func createCirculation(problem: String) {
        self.repository.postTickets(
            mainText: problem
        ) {
            result in
            DispatchQueue.main.async {
                self.isHelp = false
            }
        }
    }
    
    func startSaveSettings() {
        self.pageType = .loading
        
        if self.pictureImage != nil {
            self.commonRepository.uploadImage(
                image: pictureImage!
            ) {
                [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let url):
                        self.saveSettings(
                            pictureUrl: url,
                            firstName: self.firstName,
                            lastName: self.lastName
                        )
                        break
                    case .failure(let error):
                        print(error)
                        break
                    }
                }
            }
        }
        else if self.pictureVideo != nil {
            self.commonRepository.uploadVideo(
                video: pictureVideo!
            ) {
                [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let url):
                        self.saveSettings(
                            pictureUrl: url,
                            firstName: self.firstName,
                            lastName: self.lastName
                        )
                        break
                    case .failure(let error):
                        print(error)
                        break
                    }
                }
            }
        }
        else {
            self.saveSettings(
                pictureUrl: self.pictureUrl,
                firstName: self.firstName,
                lastName: self.lastName
            )
        }
    }
    
    private func saveSettings(
        pictureUrl: String,
        firstName: String,
        lastName: String
    ) {
        self.repository.patchProfile(
            pictureUrl: pictureUrl,
            firstName: firstName,
            lastName: lastName
        ) {
            [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileModel):
                    self.commonViewModel.profileModel!.picture_url = profileModel.picture_url
                    self.commonViewModel.profileModel!.first_name = profileModel.first_name
                    self.commonViewModel.profileModel!.last_name = profileModel.last_name
                    break
                case .failure(let error):
                    print(error)
                    break
                }
                self.pageType = .matchNotFound
                self.navigationService.navigateBack()
            }
        }
    }
    
    func deleteAccount() {
        self.repository.deleteProfile {
            [self] result in
            
            self.navigateToRoot()
        }
    }
    
    func navigateToRoot() {
        self.navigationService.index = 0
        self.navigationService.navigateToRoot()
        self.navigationService.navigate(to: .signInScreen)
    }
}
