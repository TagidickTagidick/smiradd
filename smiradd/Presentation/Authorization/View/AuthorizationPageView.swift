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
        notificationManager: NotificationManager,
        commonRepository: ICommonRepository
    ) {
        _viewModel = StateObject(
            wrappedValue: AuthorizationViewModel(
                repository: repository,
                isSignUp: isSignUp,
                navigationService: navigationService,
                locationManager: locationManager,
                notificationManager: notificationManager,
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
                            height: self.screenHeight / 60
                        ) //20
                    Image("logo")
                    Spacer()
                        .frame(
                            height: self.screenHeight / 30
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
                            height: self.screenHeight / 70
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
                        .frame(height: self.screenHeight / 40) //32
                    EmailFieldView(
                        email: self.$viewModel.email,
                        emailIsError: self.$viewModel.emailIsError,
                        emailErrorText: self.$viewModel.emailErrorText,
                        emailIsFocused: _emailIsFocused
                    )
                    .onChange(of: self.emailIsFocused) {
                        self.viewModel.checkEmail()
                    }
                    Spacer()
                        .frame(
                            height: self.screenHeight / 70
                        ) //16
                    PasswordFieldView(
                        password: self.$viewModel.password,
                        passwordIsError: self.$viewModel.passwordIsError,
                        passwordErrorText: self.$viewModel.passwordErrorText,
                        passwordIsShown: self.$viewModel.passwordIsShown,
                        passwordIsFocused: _passwordIsFocused
                    )
                    if !self.viewModel.isSignUp {
                        RecoverPasswordButtonView()
                            .onTapGesture {
                                self.viewModel.navigateToRecoverPassword()
                            }
                    }
                    Spacer()
                        .frame(
                            height: self.screenHeight / 40
                        ) //32
                    CustomButtonView(
                        text: self.viewModel.isSignUp ? "Продолжить" : "Войти",
                        color: self.viewModel.email.isEmpty || self.viewModel.password.isEmpty
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
                        screenHeight: self.screenHeight
                    )
                    Spacer()
                        .frame(
                            height: self.screenHeight / 50
                        ) //24
                    AuthorizationDividerView()
                    Spacer()
                        .frame(
                            height: self.screenHeight / 50
                        ) //24
                    OtherServiceButtonView(
                        isSignUp: self.viewModel.isSignUp
                    )
                    .onTapGesture {
                        
                    }
                    Spacer()
                        .frame(
                            height: self.screenHeight / 20
                        ) //48
                    ChangeAuthorizationButtonView(
                        isSignUp: self.viewModel.isSignUp
                    )
                    .onTapGesture {
                        self.viewModel.changeAuthorization()
                    }
                    Spacer()
                        .frame(height: self.screenHeight / 21) //46.56
                }
                .padding(
                    [.leading, .trailing],
                    self.screenHeight / 20
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
