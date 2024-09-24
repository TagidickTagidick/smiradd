import SwiftUI

struct EmailFieldView: View {
    @Binding var email: String
    @Binding var emailIsError: Bool
    @Binding var emailErrorText: String
    @FocusState var emailIsFocused: Bool
    
    var body: some View {
        VStack (alignment: .leading) {
            if emailIsError {
                Text(emailErrorText)
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
            TextField(
                "Электронная почта",
                text: $email,
                onEditingChanged: { (changed) in
                    print(changed)
                }
            )
            .focused($emailIsFocused)
            .font(
                .custom(
                    "OpenSans-Regular",
                    size: 16
                )
            )
            .foregroundStyle(
                emailIsError
                ? Color(
                    red: 0.898,
                    green: 0.271,
                    blue: 0.267
                )
                : textDefault
            )
            .accentColor(.black)
            .placeholder(when: email.isEmpty) {
                Text("Электронная почта")
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
                trailing: 20
            ))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        emailIsError
                        ? Color(red: 0.898, green: 0.271, blue: 0.267)
                        : emailIsFocused
                        ? accent400
                        : Color(
                            red: 0.4,
                            green: 0.4,
                            blue: 0.4
                        ),
                        lineWidth: emailIsFocused ? 2 : 1
                    )
            )
            .onTapGesture {
                emailIsFocused = true
                emailIsError = false
            }
        }
    }
}
