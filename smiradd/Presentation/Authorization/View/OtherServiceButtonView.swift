import SwiftUI

struct OtherServiceButtonView: View {
    var isSignUp: Bool
    
    var body: some View {
        HStack {
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
                    Text("Google")
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
            Spacer()
                .frame(
                    width: 10
                )
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
                    Image("vk_sign_in")
                    Text("VK ID")
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
}
