import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var avatarUrl: String = ""
    @Published var avatar: UIImage?
    
    @Published var firstName: String = ""
    
    @Published var lastName: String = ""
    
    @Published var isHelp: Bool = false
    
    @Published var isExit: Bool = false
    
    @Published var isDelete: Bool = false
    
    private let repository: ISettingsRepository
    
    init(
        repository: ISettingsRepository,
        firstName: String,
        lastName: String,
        avatarUrl: String
    ) {
        self.repository = repository
        self.firstName = firstName
        self.lastName = lastName
        self.avatarUrl = avatarUrl
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
}
