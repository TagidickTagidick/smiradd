import SwiftUI

class GlobalSettings: ObservableObject {
    @Published var templates: [TemplateModel] = []
}
