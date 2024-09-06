import SwiftUI

struct CardButtonView: View {
    let image: String
    let text: String
    
    var body: some View {
        HStack {
            Image(image)
            Spacer()
                .frame(width: 8)
            Text(text)
                .font(
                    .custom(
                        "OpenSans-SemiBold",
                        size: 18
                    )
                )
                .foregroundStyle(textDefault)
        }
        .cornerRadius(24)
    }
}
