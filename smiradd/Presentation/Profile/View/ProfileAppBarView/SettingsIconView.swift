import SwiftUI

struct SettingsIconView: View {
    var action: (() -> ())
    
    var body: some View {
        Image("settings")
            .onTapGesture {
                self.action()
            }
    }
}
