import SwiftUI

struct SettingsLoadingView: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 80)
            Spacer()
            ProgressView()
            Spacer()
        }
        .background(.white)
    }
}
