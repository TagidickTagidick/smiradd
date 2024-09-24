import SwiftUI

struct AuthorizationPageView: View {
    @StateObject private var viewModel: AuthorizationViewModel
    
    @FocusState private var emailIsFocused: Bool
    @FocusState private var passwordIsFocused: Bool
    
    private let screenHeight = UIScreen.main.bounds.height
    
    init(
        isSignUp: Bool,
        repository: IAuthorizationRepository,
        navigationService: NavigationService,
        commonViewModel: CommonViewModel,
        locationManager: LocationManager,
        commonRepository: ICommonRepository
    ) {
        _viewModel = StateObject(
            wrappedValue: AuthorizationViewModel(
                repository: repository,
                isSignUp: isSignUp,
                navigationService: navigationService,
                locationManager: locationManager,
                commonViewModel: commonViewModel,
                commonRepository: commonRepository
            )
        )
    }
    
    var body: some View {
        ZStack {
            if self.viewModel.isLoading {
                ProgressView()
            }
            else {
                VStack{
                    Spacer()
                        .frame(
                            height: screenHeight / 60
                        ) //20
                    Image("logo")
                    Spacer()
                        .frame(
                            height: screenHeight / 30
                        ) //36
                    Text(
                        self.viewModel.isSignUp
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
                        .frame(
                            height: screenHeight / 70
                        ) //16
                    Text(
                        self.viewModel.isSignUp
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
                    EmailFieldView(
                        email: $viewModel.email,
                        emailIsError: $viewModel.emailIsError,
                        emailErrorText: $viewModel.emailErrorText,
                        emailIsFocused: _emailIsFocused
                    )
                    Spacer()
                        .frame(
                            height: screenHeight / 70
                        ) //16
                    PasswordFieldView(
                        password: $viewModel.password,
                        passwordIsError: $viewModel.passwordIsError,
                        passwordErrorText: $viewModel.passwordErrorText,
                        passwordIsShown: $viewModel.passwordIsShown,
                        passwordIsFocused: _passwordIsFocused
                    )
                    Spacer()
                        .frame(
                            height: screenHeight / 40
                        ) //32
                    CustomButtonView(
                        text: self.viewModel.isSignUp ? "Продолжить" : "Войти",
                        color: self.viewModel.email.isEmpty || self.viewModel.password.isEmpty || !self.viewModel.isValidEmail(self.viewModel.email)
                        ? textAdditional
                        : textDefault
                    )
                    .onTapGesture {
                        self.emailIsFocused = false
                        self.passwordIsFocused = false
                        
                        if self.viewModel.isSignUp {
                            self.viewModel.signUp()
                        }
                        else {
                            self.viewModel.signIn()
                        }
                    }
                    PrivacyPolicyView(
                        isSignUp: self.viewModel.isSignUp,
                        screenHeight: screenHeight
                    )
                    Spacer()
                        .frame(
                            height: screenHeight / 50
                        ) //24
                    AuthorizationDividerView()
                    Spacer()
                        .frame(
                            height: screenHeight / 50
                        ) //24
                    OtherServiceButtonView(
                        isSignUp: self.viewModel.isSignUp
                    )
                    Spacer()
                        .frame(
                            height: screenHeight / 20
                        ) //48
                    ChangeAuthorizationButtonView(
                        isSignUp: self.viewModel.isSignUp
                    )
                    .onTapGesture {
                        self.viewModel.changeAuthorization()
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
