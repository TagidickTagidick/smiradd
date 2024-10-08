import SwiftUI
import PhotosUI

struct SettingsPageView: View {
    @EnvironmentObject private var navigationService: NavigationService
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    //@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var viewModel: SettingsViewModel
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @FocusState private var firstNameIsFocused: Bool
    
    @FocusState private var lastNameIsFocused: Bool
    
    @FocusState private var passwordIsFocused: Bool
    
    @State private var offset: CGFloat = 0
    
    init(
        repository: ISettingsRepository,
        //navigationService: NavigationService,
        firstName: String,
        lastName: String,
        avatarUrl: String
    ) {
        _viewModel = StateObject(
            wrappedValue: SettingsViewModel(
                repository: repository,
                //navigationService: navigationService,
                firstName: firstName,
                lastName: lastName,
                avatarUrl: avatarUrl
            )
        )
    }
    
    var body: some View {
        ZStack {
            if self.profileViewModel.settingsPageType == .loading {
                VStack {
                    CustomAppBarView(
                        title: "Настройки",
                        action: {
                            //self.presentationMode.wrappedValue.dismiss()
                            self.profileViewModel.closeSettings()
                        }
                    )
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding(
                    [.horizontal],
                    20
                )
            }
            else {
                ScrollView {
                    VStack (alignment: .leading) {
                        CustomAppBarView(
                            title: "Настройки",
                            action: {
                                //self.presentationMode.wrappedValue.dismiss()
                                self.profileViewModel.closeSettings()
                            }
                        )
                        Spacer()
                            .frame(height: 20)
                        SettingsInfoView(
                            avatar: $viewModel.avatar,
                            avatarUrl: $viewModel.avatarUrl,
                            videoUrl: $viewModel.avatarVideoUrl
                        )
                        Spacer()
                            .frame(height: 16)
                        CustomTextView(text: "Имя*")
                        Spacer()
                            .frame(height: 8)
                        CustomTextFieldView(
                            value: $viewModel.firstName,
                            hintText: "Введите имя",
                            focused: $firstNameIsFocused
                        )
                        Spacer()
                            .frame(height: 16)
                        CustomTextView(text: "Фамилия*")
                        Spacer()
                            .frame(height: 8)
                        CustomTextFieldView(
                            value: $viewModel.lastName,
                            hintText: "Введите фамилию",
                            focused: $lastNameIsFocused
                        )
                        Spacer()
                            .frame(height: 16)
                        if self.viewModel.firstName != (self.profileViewModel.profileModel!.first_name ?? "") || self.viewModel.lastName != (self.profileViewModel.profileModel!.last_name ?? "") || self.viewModel.avatar != nil {
                            Spacer()
                                .frame(height: 24)
                            CustomButtonView(
                                text: "Сохранить",
                                color: Color(
                                    red: 0.408,
                                    green: 0.784,
                                    blue: 0.58
                                ))
                            .onTapGesture {
                                self.profileViewModel.startSaveSettings(
                                    pictureUrl: self.viewModel.avatarUrl,
                                    picture: self.viewModel.avatar,
                                    firstName: self.viewModel.firstName,
                                    lastName: self.viewModel.lastName
                                )
                            }
                        }
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
                                    focused: self.$passwordIsFocused
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
                            }) {
                                CirculationCreationView(isHelp: $viewModel.isHelp)
                                    .environmentObject(self.viewModel)
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
                            UserDefaults.standard.removeObject(
                                forKey: "forum_code"
                            )
                            UserDefaults.standard.removeObject(
                                forKey: "is_team"
                            )
                            UserDefaults.standard.removeObject(
                                forKey: "access_token"
                            )
                            UserDefaults.standard.removeObject(
                                forKey: "refresh_token"
                            )
                            UserDefaults.standard.removeObject(
                                forKey: "first_time_forum"
                            )
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
                            self.profileViewModel.deleteAccount()
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
                        Spacer()
                            .frame(height: 74)
                    }
                    .padding(
                        [.horizontal],
                        20
                    )
                }
                .background(.white)
                .navigationBarBackButtonHidden(true)
                .onTapGesture {
                    firstNameIsFocused = false
                    lastNameIsFocused = false
                }
            }
        }
    }
}
