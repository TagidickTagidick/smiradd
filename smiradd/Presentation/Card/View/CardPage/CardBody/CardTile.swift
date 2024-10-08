import SwiftUI

struct CardTileView: View {
    let icon: String
    let text: String
    let isUrl: Bool
    
    var body: some View {
        HStack {
            Image(self.icon)
                .frame(
                    width: 24,
                    height: 24
                )
            Spacer()
                .frame(width: 8)
            if self.isUrl {
                Link(
                    self.text,
                    destination: URL(string: self.text)!
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
                Text(self.text)
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
