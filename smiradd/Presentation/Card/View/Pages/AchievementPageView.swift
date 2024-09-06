import SwiftUI

struct AchievementPageView: View {
    @EnvironmentObject var router: NavigationService
    
    @EnvironmentObject var viewModel: CardViewModel
    
    @State var name: String = ""
    @FocusState private var nameIsFocused: Bool
    
    @State var description: String = ""
    @FocusState private var descriptionIsFocused: Bool
    
    @State var url: String = ""
    @FocusState private var urlIsFocused: Bool
    
    @State private var isAlert = false
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                CustomAppBar(
                    title: self.viewModel.achievementIndex == -1
                    ? "Создание достижения"
                    : "Изменение достижения"
                )
                .padding(
                    [.vertical],
                    8
                )
                Spacer()
                    .frame(height: 20)
                Text("Название*")
                    .font(
                        .custom(
                            "OpenSans-Medium",
                            size: 14
                        )
                    )
                    .foregroundStyle(textAdditional)
                Spacer()
                    .frame(height: 12)
                CustomTextField(
                    value: $name,
                    hintText: "Введите название достижения",
                    focused: $nameIsFocused
                )
                .onTapGesture {
                    nameIsFocused = true
                }
                Spacer()
                    .frame(height: 20)
                Text("Описание")
                    .font(
                        .custom(
                            "OpenSans-Medium",
                            size: 14
                        )
                    )
                    .foregroundStyle(textAdditional)
                Spacer()
                    .frame(height: 12)
                CustomTextField(
                    value: $description,
                    hintText: "Кратко опишите достижение",
                    focused: $descriptionIsFocused,
                    height: 103,
                    limit: 500,
                    isLongText: true
                )
                .lineLimit(5)
                .onTapGesture {
                    descriptionIsFocused = true
                }
                Spacer()
                    .frame(height: 20)
                Text("Ссылка")
                    .font(
                        .custom(
                            "OpenSans-Medium",
                            size: 14
                        )
                    )
                    .foregroundStyle(textAdditional)
                Spacer()
                    .frame(height: 12)
                CustomTextField(
                    value: $url,
                    hintText: "Вставьте ссылку",
                    focused: $urlIsFocused
                )
                .onTapGesture {
                    urlIsFocused = true
                }
                if self.viewModel.achievementIndex != -1 {
                    DeleteWidget(text: "достижение")
                        .onTapGesture {
                            isAlert.toggle()
                        }
                        .customAlert(
                                        "Удалить?",
                                        isPresented: $isAlert,
                                        actionText: "Удалить"
                                    ) {
                                        self.viewModel.achievements.remove(at: self.viewModel.achievementIndex)
                                        router.navigateBack()
                                    } message: {
                                        Text("Достижение и вся информация в нем будут удалены. Удалить достижение?")
                                    }
                }
                Spacer()
                    .frame(height: 32)
                Spacer()
                CustomButton(
                    text: "Сохранить",
                    color: !name.isEmpty ? Color(
                    red: 0.408,
                    green: 0.784,
                    blue: 0.58
                ) : Color(
                    red: 0.867,
                    green: 0.867,
                    blue: 0.867
                ))
                    .onTapGesture {
                        if !name.isEmpty {
                            self.viewModel.achievements.append(AchievementModel(
                                name: name,
                                description: description,
                                url: url
                            ))
                            router.navigateBack()
                        }
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
        .onAppear {
            self.name = self.viewModel.achievementIndex == -1 ? "" : self.viewModel.achievements[self.viewModel.achievementIndex].name
            self.description = self.viewModel.achievementIndex == -1 ? "" : self.viewModel.achievements[self.viewModel.achievementIndex].description
            self.url = self.viewModel.achievementIndex == -1 ? "" : self.viewModel.achievements[self.viewModel.achievementIndex].url
        }
        .onTapGesture {
            nameIsFocused = false
            descriptionIsFocused = false
            urlIsFocused = false
        }
    }
}
