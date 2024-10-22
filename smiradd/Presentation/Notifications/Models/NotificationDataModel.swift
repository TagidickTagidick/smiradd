struct NotificationDataModel: Codable {
    let first_name: String
    let uuid_sender: String
    let last_name: String
    let avatar_url: String?
    let invite_url: String?
    let text: String
}
