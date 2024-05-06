import SwiftUI

struct AuthorizationModel: Codable {
    let access_token: String
    let refresh_token: String
}
