import SwiftUI

struct RestorePasswordPageView: View {
    @StateObject private var viewModel: RestorePasswordViewModel
    
    @EnvironmentObject private var navigationService: NavigationService
    
    @FocusState private var emailIsFocused: Bool
    
    @FocusState private var codeIsFocused: Bool
    
    private let screenHeight = UIScreen.main.bounds.height
    
    init(
        repository: IRestorePasswordRepository,
        navigationService: NavigationService
    ) {
        _viewModel = StateObject(
            wrappedValue: RestorePasswordViewModel(
                repository: repository,
                navigationService: navigationService
            )
        )
    }
    
    var body: some View {
        VStack {
            Spacer()
                .frame(
                    height: screenHeight / 50
                ) //20
            HStack {
                Image(systemName: "arrow.left")
                    .foregroundColor(buttonClick)
                    .onTapGesture {
                        self.navigationService.navigateBack()
                    }
                Spacer()
            }
            Spacer()
            Spacer()
                .frame(
                    height: screenHeight / 50
                ) //20
            Image("logo")
            Spacer()
                .frame(
                    height: screenHeight / 30
                ) //36
            Text("Восстановление учётной записи")
            .multilineTextAlignment(.center)
            .font(
                .custom(
                    "OpenSans-SemiBold",
                    size: 30
                )
            )
            .foregroundStyle(textDefault)
            Spacer()
                .frame(height: screenHeight / 40) //32
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
                    height: screenHeight / 40
                ) //32
            if self.viewModel.timeRemaining == 0 {
                CustomButtonView(
                    text: self.viewModel.timeRemaining == 0
                    ? "Отправить код подтверждения"
                    : "Отправить код через: \(self.viewModel.timeRemaining)",
                    color: self.viewModel.timeRemaining == 0 && self.viewModel.isValidEmail
                    ? textDefault : .gray
                )
                .onTapGesture {
                    self.viewModel.sendCode()
                }
            }
            else {
                CustomButtonView(
                    text: self.viewModel.timeRemaining == 0
                    ? "Отправить код подтверждения"
                    : "Отправить код через: \(self.viewModel.timeRemaining)",
                    color: self.viewModel.timeRemaining == 0 && self.viewModel.isValidEmail
                    ? textDefault : .gray
                )
                .onReceive(self.viewModel.timer!) { _ in
                                if self.viewModel.timeRemaining > 0 {
                                    self.viewModel.timeRemaining -= 1
                                }
                }
            }
            Spacer()
                .frame(
                    height: screenHeight / 20
                ) //48
            if self.viewModel.showPinCode {
                Text("Код был отправлен на указанный email")
                PinEntryView(pinCode: self.$viewModel.code)
                    .onChange(of: self.viewModel.code) {
                        self.viewModel.confirmCode()
                    }
            }
            Spacer()
                .frame(height: screenHeight / 21) //46.56
            Spacer()
        }
        .padding(
            [.horizontal],
            20
        )
        .navigationBarBackButtonHidden(true)
        //.ignoresSafeArea(.keyboard)
        .background(.white)
        .onTapGesture {
            emailIsFocused = false
            codeIsFocused = false
        }
        .networkingAlert(
            "Удалить визитку?",
            isPresented: self.$viewModel.isSheet,
            actionText: "Удалить",
            image: "no_results_found",
            title: "Сгенерированный пароль отправлен вам на почту",
            description: self.viewModel.email,
            action: {
                self.viewModel.navigateToSignIn()
            },
            message: {
                CustomButtonView(
                    text: "Отлично",
                    color: textDefault,
                    width: UIScreen.main.bounds.width - 80
                )
                .onTapGesture {
                    self.viewModel.navigateToSignIn()
                }
            }
        )
    }
}
