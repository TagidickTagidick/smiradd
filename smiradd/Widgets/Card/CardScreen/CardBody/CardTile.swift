import SwiftUI

struct CardTile: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack {
            Image(icon)
                .frame(
                    width: 24,
                    height: 24
                )
            Spacer()
                .frame(width: 8)
            Text(text)
                .font(
                    .custom(
                        "OpenSans-Regular",
                        size: 16
                    )
                )
                .foregroundStyle(textDefault)
        }
    }
}
