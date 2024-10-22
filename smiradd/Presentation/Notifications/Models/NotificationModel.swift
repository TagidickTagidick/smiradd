struct NotificationModel: Codable, Identifiable {
    let id: String
    var status: String
    let data: NotificationDataModel
    let created_at: String
    var accepted: Bool?
    let type: String?
    
    static let mock: NotificationModel = NotificationModel(
        id: "e6671d9e-c2e2-496f-8729-83d1c729cf0c",
        status: "READED",
        data: NotificationDataModel(
            first_name: "user",
            uuid_sender: "0dae6d4f-29f0-42ba-81e2-bb6eb436a840",
            last_name: "67341",
            avatar_url: nil,
            invite_url: nil,
            text: "Хочет попасть к вам в команду Стартап-студия «Структура»"
        ),
        created_at: "2024-05-29T07:36:14.275624",
        type: "like"
    )
}
