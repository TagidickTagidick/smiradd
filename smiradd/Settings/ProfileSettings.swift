import SwiftUI

class ProfileSettings: ObservableObject {
    @Published var profileModel: ProfileModel?
    @Published var notificationsModel: NotificationsModel?
    @Published var cards: [CardModel] = []
    @Published var templates: [TemplateModel] = []
}
