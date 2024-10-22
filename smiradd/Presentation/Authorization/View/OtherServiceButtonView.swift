import SwiftUI
import VKID

struct OtherServiceButtonView: View {
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
                do {
                    let vkid = try VKID(
                        config: Configuration(
                            appCredentials: AppCredentials(
                                clientId: "51915511",         // ID вашего приложения
                                clientSecret: "2ca8eec22ca8eec22ca8eec2312fb0c43522ca82ca8eec24a983499e502b84689c6937e"  // ваш защищенный ключ (client_secret)
                            )
                        )
                    )
                } catch {
                    preconditionFailure("Failed to initialize VKID: \(error)")
                }
                //handleSignInButton()
            }
        }
    }
}
