struct TeamMainModel: Codable {
    var team: TeamModel
    let owner_card_id: String?
    var teammates: [CardModel]
    
    static let mock: TeamMainModel = TeamMainModel(
        team: TeamModel(
            name: "Стартап-студия “Структура”",
            about_team: "",
            about_project: "",
            team_logo: "",
            invite_url: "",
            bc_template_type: "96e565a0-6745-4ce6-9827-bffd9c2829a2",
            id: ""
        ),
        owner_card_id: "",
        teammates: []
    )
}
