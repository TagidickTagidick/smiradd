import SwiftUI

struct PasswordField: View {
    @Binding var password: String
    @Binding var passwordIsError: Bool
    @Binding var passwordIsShown: Bool
    @FocusState var passwordIsFocused: Bool
    
    var body: some View {
        VStack (alignment: .leading) {
            ZStack (alignment: .trailing) {
                if passwordIsShown {
                    TextField(
                        "Пароль",
                        text: $password
                    )
                    .focused($passwordIsFocused)
                    .font(
                        .custom(
                            "OpenSans-Regular",
                            size: 16
                        )
                    )
                    .foregroundStyle(
                        passwordIsError
                        ? Color(
                            red: 0.898,
                            green: 0.271,
                            blue: 0.267
                        )
                        : textDefault
                    )
                    .accentColor(.black)
                    .placeholder(when: password.isEmpty) {
                        Text("Пароль")
                            .foregroundColor(Color(
                                red: 0.4,
                                green: 0.4,
                                blue: 0.4
                            ))
                    }
                    .frame(height: 56)
                    .padding(EdgeInsets(
                        top: 0,
                        leading: 20,
                        bottom: 0,
                        trailing: 50
                    ))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                passwordIsError
                                ? Color(red: 0.898, green: 0.271, blue: 0.267)
                                : passwordIsFocused
                                ? accent400
                                : Color(
                                    red: 0.4,
                                    green: 0.4,
                                    blue: 0.4
                                ),
                                lineWidth: passwordIsFocused ? 2 : 1
                            )
                    )
                    .onTapGesture {
                        passwordIsFocused = true
                        passwordIsError = false
                    }
                }
                else {
                    SecureField(
                        "Пароль",
                        text: $password
                    )
                    .focused($passwordIsFocused)
                    .font(
                        .custom(
                            "OpenSans-Regular",
                            size: 16
                        )
                    )
                    .foregroundStyle(
                        passwordIsError
                        ? Color(
                            red: 0.898,
                            green: 0.271,
                            blue: 0.267
                        )
                        : textDefault
                    )
                    .accentColor(.black)
                    .placeholder(when: password.isEmpty) {
                        Text("Пароль")
                            .foregroundColor(Color(
                                red: 0.4,
                                green: 0.4,
                                blue: 0.4
                            ))
                    }
                    .frame(height: 56)
                    .padding(EdgeInsets(
                        top: 0,
                        leading: 20,
                        bottom: 0,
                        trailing: 50
                    ))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                passwordIsError
                                ? Color(red: 0.898, green: 0.271, blue: 0.267)
                                : passwordIsFocused
                                ? accent400
                                : Color(
                                    red: 0.4,
                                    green: 0.4,
                                    blue: 0.4
                                ),
                                lineWidth: passwordIsFocused ? 2 : 1
                            )
                    )
                    .onTapGesture {
                        passwordIsFocused = true
                        passwordIsError = false
                    }
                }
                Image(passwordIsShown ? "eye_close" : "eye_open")
                    .offset(x: -16)
                    .onTapGesture {
                        passwordIsShown = !passwordIsShown
                    }
            }
            if passwordIsError {
                Text("Неверный пароль")
                    .font(
                        .custom(
                            "OpenSans-Regular",
                            size: 14
                        )
                    )
                    .foregroundStyle(
                        Color(
                            red: 0.898,
                            green: 0.271,
                            blue: 0.267
                        )
                    )
            }
        }
    }
}
