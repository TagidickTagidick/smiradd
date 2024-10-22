import SwiftUI

struct NotificationsModel: Codable {
    var items: [NotificationModel]
    let total: Int
    let page: Int
    let size: Int
    let pages: Int
}
