struct NotificationModel: Codable, Identifiable {
    let id: String
    var status: String
    let data: NotificationDataModel
    let created_at: String
    var accepted: Bool?
    let type: String?
}
