import SwiftUI

struct CustomButton: View {
    var text: String
    
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
            width: UIScreen.main.bounds.width - 40,
            height: 56
        )
        .background(textDefault)
        .cornerRadius(28)
    }
}
