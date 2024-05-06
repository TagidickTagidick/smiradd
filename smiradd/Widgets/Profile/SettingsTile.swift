import SwiftUI

struct SettingsTile: View {
    @EnvironmentObject var router: Router
    
    var image: String
    var text: String
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 12)
            HStack {
                Image(image)
                    .frame(
                        width: 24,
                        height: 24
                    )
                Spacer()
                    .frame(width: 12)
                Text(text)
                    .font(
                        .custom(
                            "OpenSans-SemiBold",
                            size: 16
                        )
                    )
                    .foregroundStyle(textDefault)
            }
            Spacer()
                .frame(height: 8)
        }
    }
}
