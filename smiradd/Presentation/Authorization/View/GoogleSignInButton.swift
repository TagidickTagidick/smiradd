import SwiftUI

struct GoogleSignInButton: View {
    var isSignUp: Bool
    
    var body: some View {
        ZStack {
            Spacer()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: 56
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(textDefault)
                )
            HStack {
                Image("google")
                Text(
                    isSignUp
                    ? "Продолжить с Google"
                    : "Войти c Google"
                )
                .font(
                    .custom(
                        "OpenSans-SemiBold",
                        size: 16
                    )
                )
                .foregroundStyle(textDefault)
            }
            .onTapGesture {
                //handleSignInButton()
            }
        }
    }
}
