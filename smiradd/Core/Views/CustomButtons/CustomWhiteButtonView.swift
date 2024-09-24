import SwiftUI

struct CustomWhiteButtonView: View {
    var text: String
    
    var body: some View {
        ZStack {
            Spacer()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: 56
                )
                .background(.white)
                .cornerRadius(28)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(textDefault)
                )
            Text(text)
                .font(
                    .custom(
                        "OpenSans-SemiBold",
                        size: 16
                    )
                )
                .foregroundStyle(textDefault)
        }
    }
}
