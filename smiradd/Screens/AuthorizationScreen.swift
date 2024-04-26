import SwiftUI

struct AuthorizationScreen: View {
    var isSignUp: Bool
    
    @EnvironmentObject var router: Router
    
    @State private var isLoading: Bool = false
    
    @State private var email: String = ""
    @FocusState private var emailIsFocused: Bool
    @State private var emailIsError: Bool = false
    
    @State private var password: String = ""
    @State private var passwordIsShown: Bool = false
    @State private var passwordIsError: Bool = false
    @FocusState private var passwordIsFocused: Bool
    
    let screenHeight = UIScreen.main.bounds.height
    
    func fetchData() {
        self.isLoading = true
        
        guard let url = URL(string: "http://80.90.185.153:5002/api/auth/\(isSignUp ? "registration" : "login")") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )

            let parameters: [String: Any] = [
                "email": email,
                "password": password,
                "role": "user"
            ]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                print("Error encoding parameters: \(error)")
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                do {
                    let httpResponse = response as? HTTPURLResponse
                    switch httpResponse?.statusCode {
                    case 200:
                        let authorizationModel = try JSONDecoder().decode(AuthorizationModel.self, from: data)
                        print(authorizationModel)
                        UserDefaults.standard.set(
                            authorizationModel.access_token,
                            forKey: "access_token"
                        )
                        UserDefaults.standard.set(
                            authorizationModel.refresh_token,
                            forKey: "refresh_token"
                        )
                        DispatchQueue.main.async {
                            self.isLoading = false
                            router.navigate(to: .networkingScreen)
                        }
                    case 400:
                        let string = String(data: data, encoding: .utf8)
                        if string!.contains("Passwords did not match") {
                            self.passwordIsError = true
                        }
                        else {
                            self.emailIsError = true
                        }
                        self.isLoading = false
                    case 404:
                        self.emailIsError = true
                        self.isLoading = false
                    default:
                        self.isLoading = false
                        break
                    }
                } catch {}
            }.resume()
        }
    
//                let url = URL(string: "http://80.90.185.153:5002/api/auth/registration")!
//                URLSession.shared.dataTask(with: url) { data, response, error in
//                    guard let data = data else { return }
//                    do {
//                        let decodedData = try JSONDecoder().decode(AuthorizationModel.self, from: data)
//                        print(decodedData)
//                        DispatchQueue.main.async {
//                            self.users = decodedData
//                        }
//                    } catch {
//                        print(error)
//                    }
//                }.resume()
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
            }
            else {
                VStack{
                    Spacer()
                        .frame(height: screenHeight / 60) //20
                    Image("logo")
                    Spacer()
                        .frame(height: screenHeight / 30) //36
                    Text(
                        isSignUp
                        ? "Регистрация"
                        : "Добро пожаловать!"
                    )
                        .multilineTextAlignment(.center)
                        .font(
                            .custom(
                                "OpenSans-SemiBold",
                                size: 30
                            )
                        )
                        .foregroundStyle(textDefault)
                    Spacer()
                        .frame(height: screenHeight / 70) //16
                    Text(
                        isSignUp
                        ? "Пожалуйста, укажите следующие детали для Вашей новой учетной записи"
                        : "Войдите, чтобы продолжить"
                    )
                        .multilineTextAlignment(.center)
                        .font(
                            .custom(
                                "OpenSans-Regular",
                                size: 14
                            )
                        )
                        .foregroundStyle(textDefault)
                    Spacer()
                        .frame(height: screenHeight / 40) //32
                    VStack (alignment: .leading) {
                        if emailIsError {
                            Text(
                                isSignUp
                                ? "Аккаунт с такой эл. почтой уже существует"
                                : "Не существует аккаунта с такой эл. почтой"
                            )
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
                        Spacer()
                            .frame(height: screenHeight / 70) //16
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
                    Spacer()
                        .frame(height: screenHeight / 40) //32
                    ZStack {
                        Spacer()
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: 56
                            )
                            .background(textDefault)
                            .cornerRadius(28)
                        Text("Войти")
                            .font(
                                .custom(
                                    "OpenSans-SemiBold",
                                    size: 16
                                )
                            )
                            .foregroundStyle(.white)
                    }
                    .onTapGesture {
                        emailIsFocused = false
                        passwordIsFocused = false
                        fetchData()
                    }
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
                    Spacer()
                        .frame(height: screenHeight / 50) //24
                    HStack {
                        Spacer()
                            .frame(height: 1)
                            .background(textDefault)
                        Spacer()
                            .frame(width: 16)
                        Text("или")
                            .font(
                                .custom(
                                    "OpenSans-SemiBold",
                                    size: 15
                                )
                            )
                            .foregroundStyle(textDefault)
                        Spacer()
                            .frame(width: 16)
                        Spacer()
                            .frame(height: 1)
                            .background(textDefault)
                    }
                    Spacer()
                        .frame(height: screenHeight / 50) //24
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
                    }
                    .onTapGesture {
                        print("рыры")
                    }
                    Spacer()
                        .frame(height: screenHeight / 20) //48
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
                    .onTapGesture {
                        router.navigate(
                            to: isSignUp
                            ? .signInScreen
                            : .signUpScreen
                        )
                    }
                    Spacer()
                        .frame(height: screenHeight / 21) //46.56
                }
                .padding(
                    [.leading, .trailing],
                    screenHeight / 20
                )
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.keyboard)
        .background(.white)
        .onTapGesture {
            emailIsFocused = false
            passwordIsFocused = false
        }
    }
}

struct User: Codable, Identifiable {
    let id: Int
    let name: String
}
