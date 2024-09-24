struct TeamModel: Codable, Identifiable {
    let name: String
    let about_team: String?
    let about_project: String?
    let team_logo: String?
    let invite_url: String
    var bc_template_type: String?
    let id: String?
}
