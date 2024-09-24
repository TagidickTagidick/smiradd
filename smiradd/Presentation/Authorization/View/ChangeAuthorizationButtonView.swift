import SwiftUI

struct ChangeAuthorizationButtonView: View {
    var isSignUp: Bool
    
    var body: some View {
        HStack {
            Text(
                isSignUp
                ? "Уже есть аккаунт?"
                : "Нет аккаунта? "
            )
            .font(
                .custom(
                    "OpenSans-Regular",
                    size: 16
                )
            )
            .foregroundStyle(textDefault)
            Text(
                isSignUp
                ? "Войти"
                : "Создать аккаунт"
            )
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
