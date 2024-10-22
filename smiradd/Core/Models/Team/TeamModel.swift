struct TeamModel: Codable, Identifiable {
    var name: String
    var about_team: String?
    var about_project: String?
    var team_logo: String?
    var invite_url: String
    var bc_template_type: String?
    let id: String?
    
    static let mocks: [TeamModel] = []
}
