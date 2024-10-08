import SwiftUI

struct RestorePasswordPageView: View {
    @StateObject private var viewModel: RestorePasswordViewModel
    
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
                email: $viewModel.email,
                emailIsError: $viewModel.emailIsError,
                emailErrorText: $viewModel.emailErrorText,
                emailIsFocused: _emailIsFocused
            )
            Spacer()
                .frame(
                    height: screenHeight / 40
                ) //32
            CustomButtonView(
                text: self.viewModel.timeRemaining == 0
                ? "Отправить код подтверждения"
                : "Отправить код через: \(self.viewModel.timeRemaining)",
                color: self.viewModel.timeRemaining == 0
                ? textDefault : .gray
            )
            .onTapGesture {
                self.viewModel.sendCode()
            }
            Spacer()
                .frame(
                    height: screenHeight / 20
                ) //48
            if self.viewModel.showPinCode {
                Text("Код был отправлен на указанный email")
                PinEntryView(pinCode: self.$viewModel.code)
                    .onChange(of: self.viewModel.code) {
                        if (self.viewModel.code.count == 4) {
                            self.viewModel.confirmCode()
                        }
                    }
            }
            Spacer()
                .frame(height: screenHeight / 21) //46.56
        }
        .padding(
            [.leading, .trailing],
            screenHeight / 20
        )
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.keyboard)
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
