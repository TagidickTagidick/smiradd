import SwiftUI

struct TeamEditView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @EnvironmentObject var viewModel: TeamViewModel
    
    @FocusState var nameIsFocused: Bool
    
    @FocusState var aboutTeamIsFocused: Bool
    
    @FocusState var aboutProjectIsFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                CardImageView(
                    image: self.$viewModel.logo,
                    videoUrl: self.$viewModel.logoVideoUrl,
                    imageUrl: self.$viewModel.logoUrl,
                    showTrailing: false,
                    editButton: false
                )
                .frame(height: 360)
                VStack (alignment: .leading) {
                    Spacer()
                        .frame(
                            height: 16
                        )
                    CustomTextView(
                        text: "Название команды",
                        isRequired: true
                    )
                    Spacer()
                        .frame(
                            height: 12
                        )
                    CustomTextFieldView(
                        value: $viewModel.name,
                        hintText: "Введите должность",
                        focused: $nameIsFocused
                    )
                    Spacer()
                        .frame(
                            height: 16
                        )
                    CustomTextView(text: "О команде")
                    Spacer()
                        .frame(
                            height: 12
                        )
                    CustomTextFieldView(
                        value: $viewModel.aboutTeam,
                        hintText: "Расскажите о себе",
                        focused: $aboutTeamIsFocused,
                        height: 177,
                        limit: 800,
                        isLongText: true
                    )
                    Spacer()
                        .frame(
                            height: 16
                        )
                    CustomTextView(text: "О проекте")
                    Spacer()
                        .frame(
                            height: 12
                        )
                    CustomTextFieldView(
                        value: $viewModel.aboutProject,
                        hintText: "Расскажите о проекте",
                        focused: $aboutProjectIsFocused,
                        height: 177,
                        limit: 800,
                        isLongText: true
                    )
                    Spacer()
                        .frame(
                            height: 16
                        )
                    CustomTextView(
                        text: "Шаблон визитки"
                    )
                    Spacer()
                        .frame(
                            height: 12
                        )
                    TeamTemplateView(
                        teamMainModel: self.viewModel.teamMainModel
                    )
                        .onTapGesture {
                            self.viewModel.openTemplates()
                        }
                        .navigationDestination(
                            isPresented: $viewModel.templatesOpened
                        ) {
                        TeamTemplatesPageView()
                            .environmentObject(self.viewModel)
                    }
                    if self.viewModel.teamType == .editCard {
                        Spacer()
                            .frame(
                                height: 16
                            )
                        CustomTextView(
                            text: "Участники"
                        )
                        Spacer()
                            .frame(
                                height: 12
                            )
                        ForEach(self.viewModel.teamMainModel.teammates) {
                            teammate in
                            MyCardView(
                                cardModel: teammate,
                                isMyCard: false,
                                onDislike: {
                                    id in
                                    self.viewModel.dislike(id: id)
                                }
                            )
                            .customAlert(
                                "Удалить участника?",
                                isPresented: $viewModel.isKick,
                                actionText: "Удалить"
                            ) {
                                self.viewModel.kick()
                            } message: {
                                Text("Участник будет удален из команды. Вы действительно хотите удалить участника?")
                            }
                            Spacer()
                                .frame(
                                    height: 12
                                )
                        }
                        ShareLink(
                            item: URL(
                                string: "https://smiradd.ru/teams/invite/\(self.viewModel.teamId)"
                            )!
                        ) {
                            CustomButtonView(
                                text: "Добавить",
                                color: textDefault
                            )
                        }
                    }
                    if self.viewModel.teamType == .editCard {
                        DeleteView(text: "команду")
                            .onTapGesture {
                                self.viewModel.openAlert()
                            }
                            .customAlert(
                                "Отменить создание команды?",
                                isPresented: $viewModel.isAlert,
                                actionText: "Удалить"
                            ) {
                                self.viewModel.deleteTeam()
                            } message: {
                                Text("Команда и вся информация о ней будут удалены. Удалить команду?")
                            }
                    }
                    Spacer()
                        .frame(height: 32)
                    CustomButtonView(
                        text: "Сохранить",
                        color: !self.viewModel.name.isEmpty ? Color(
                            red: 0.408,
                            green: 0.784,
                            blue: 0.58
                        ) : Color(
                            red: 0.867,
                            green: 0.867,
                            blue: 0.867
                        )
                    )
                        .onTapGesture {
                            self.viewModel.startSave()
                        }
                    Spacer()
                        .frame(
                            height: 74 + self.safeAreaInsets.bottom
                        )
                }
                .padding(
                    [.horizontal],
                    20
                )
            }
        }
        .onTapGesture {
            nameIsFocused = false
            aboutTeamIsFocused = false
            aboutProjectIsFocused = false
        }
    }
}
