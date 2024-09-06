import SwiftUI

struct NotificationsModel: Codable {
    let items: [NotificationModel]
    let total: Int
    let page: Int
    let size: Int
    let pages: Int
}

struct NotificationModel: Codable, Identifiable {
    let id: String
    let text: String
    let avatar_url: String?
    let created_at: String
    let status: String
    let first_name: String?
    let last_name: String?
}
