import SwiftUI

struct CardTile: View {
    var icon: String
    var text: String
    var isUrl: Bool
    
    var body: some View {
        HStack {
            Image(icon)
                .frame(
                    width: 24,
                    height: 24
                )
            Spacer()
                .frame(width: 8)
            if isUrl {
                Link(
                    text,
                    destination: URL(string: text)!
                )
                .font(
                    .custom(
                        "OpenSans-Regular",
                        size: 16
                    )
                )
                .foregroundStyle(accent600)
                .frame(height: 24)
            }
            else {
                Text(text)
                    .font(
                        .custom(
                            "OpenSans-Regular",
                            size: 16
                        )
                    )
                    .foregroundStyle(textDefault)
                    .frame(height: 24)
            }
        }
    }
}
