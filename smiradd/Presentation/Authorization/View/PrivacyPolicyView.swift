import SwiftUI

struct PrivacyPolicyView: View {
    var isSignUp: Bool
    var screenHeight: CGFloat
    
    var body: some View {
        VStack {
            if isSignUp {
                Spacer()
                    .frame(height: screenHeight / 70) //16
                Text("Нажимая на кнопку, вы даете согласие на обработку персональных данных и соглашаетесь c ")
                    .font(
                        .custom(
                            "OpenSans-Regular",
                            size: 12
                        )
                    )
                    .foregroundStyle(Color(
                        red: 0.4,
                        green: 0.4,
                        blue: 0.4
                    ))
                + Text("политикой конфиденциальности")
                    .font(
                        .custom(
                            "OpenSans-Regular",
                            size: 12
                        )
                    )
                    .foregroundStyle(textDefault)
                    .underline()
            }
        }
    }
}
