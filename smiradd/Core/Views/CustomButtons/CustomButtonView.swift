import SwiftUI

struct CustomButtonView: View {
    var text: String
    var color: Color
    var width: CGFloat? = nil
    
    var body: some View {
        ZStack {
            Text(text)
                .font(
                    .custom(
                        "OpenSans-SemiBold",
                        size: 16
                    )
                )
                .foregroundStyle(.white)
        }
        .frame(
            width: width ?? (UIScreen.main.bounds.width - 40),
            height: 56
        )
        .background(color)
        .cornerRadius(28)
    }
}
