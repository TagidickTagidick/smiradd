import SwiftUI

struct RecoverPasswordButtonView: View {
    
    var body: some View {
        HStack {
            Text("Забыли пароль,")
            .font(
                .custom(
                    "OpenSans-Regular",
                    size: 16
                )
            )
            .foregroundStyle(textDefault)
            Text("восстановить?")
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

