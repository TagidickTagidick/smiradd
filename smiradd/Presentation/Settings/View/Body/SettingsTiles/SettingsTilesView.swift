import SwiftUI

struct SettingsTilesView: View {
    @EnvironmentObject var viewModel: SettingsViewModel
    @EnvironmentObject var commonViewModel: CommonViewModel
    @EnvironmentObject var navigationService: NavigationService
    
    var passwordIsFocused: FocusState<Bool>.Binding
    
    var body: some View {
        SettingsTileView(
            image: "change_pattern",
            text: "Смена пароля"
        )
        .onTapGesture {
            self.viewModel.openChangePasswordSheet()
        }
        .customAlert(
            "Смена пароля",
            isPresented: self.$viewModel.isChangePassword,
            actionText: "Сменить",
            isRed: true
        ) {
            self.viewModel.changePassword()
        } message: {
            VStack (alignment: .leading) {
                CustomTextView(text: "Новый пароль")
                Spacer()
                    .frame(height: 10)
                CustomTextFieldView(
                    value: self.$viewModel.password,
                    hintText: "",
                    focused: self.passwordIsFocused
                )
            }
        }
        Spacer()
            .frame(height: 16)
        SettingsTileView(
            image: "help",
            text: "Помощь"
        )
        .onTapGesture {
            self.viewModel.openHelpAlert()
        }
        .sheet(
            isPresented: $viewModel.isHelp,
            onDismiss: {
                self.viewModel.closeHelpAlert()
            }
        ) {
            CirculationCreationView(
                action: {
                    problem in
                    self.viewModel.createCirculation(problem: problem)
                }
            )
            .environment(\.sizeCategory, .medium)
        }
        Spacer()
            .frame(height: 16)
        SettingsTileView(
            image: "exit",
            text: "Выйти"
        )
        .onTapGesture {
            self.viewModel.openExitAlert()
        }
        .customAlert(
            "Выйти из аккаунта?",
            isPresented: $viewModel.isExit,
            actionText: "Выйти"
        ) {
            self.commonViewModel.removeAll()
            
            self.navigationService.index = 0
            self.navigationService.navigateToRoot()
            self.navigationService.navigate(
                to: .signInScreen
            )
        } message: {
            Text("Вы точно хотите выйти из аккаунта?")
                .font(
                    .custom(
                        "OpenSans-Regular",
                        size: 14
                    )
                )
                .foregroundStyle(textDefault)
        }
        Spacer()
            .frame(height: 16)
        SettingsTileView(
            image: "delete_account",
            text: "Удалить аккаунт"
        )
        .onTapGesture {
            self.viewModel.openDeleteAlert()
        }
        .customAlert(
            "Удалить аккаунт?",
            isPresented: $viewModel.isDelete,
            actionText: "Удалить"
        ) {
            self.commonViewModel.removeAll()
            self.navigationService.index = 0
            self.viewModel.deleteAccount()
        } message: {
            Text("Все ваши визитки и визитки, которые вы добавили в избранное будут удалены. Удалить аккаунт?")
                .font(
                    .custom(
                        "OpenSans-Regular",
                        size: 14
                    )
                )
                .foregroundStyle(textDefault)
        }
    }
}
