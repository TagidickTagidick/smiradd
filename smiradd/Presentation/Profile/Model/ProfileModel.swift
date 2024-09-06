import SwiftUI

struct ProfileModel: Codable {
    var first_name: String?
    var last_name: String?
    var picture_url: String?
    let email: String
    let default_card: String?
    let role: String
}
