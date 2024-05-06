import SwiftUI

struct TemplateModel: Codable, Identifiable {
    let id: String
    let title: String
    let picture_url: String?
    let theme: String
}

