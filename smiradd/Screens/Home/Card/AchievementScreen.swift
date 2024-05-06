import SwiftUI

struct AchievementScreen: View {
    @EnvironmentObject var router: Router
    
    @EnvironmentObject var cardSettings: CardSettings
    
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
                    title: cardSettings.achievementIndex == -1
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
                if cardSettings.achievementIndex != -1 {
                    DeleteWidget(text: "достижение")
                        .onTapGesture {
                            isAlert.toggle()
                        }
                        .customAlert(
                                        "Удалить?",
                                        isPresented: $isAlert,
                                        actionText: "Удалить"
                                    ) {
                                        cardSettings.achievements.remove(at: cardSettings.achievementIndex)
                                        router.navigateBack()
                                    } message: {
                                        Text("Достижение и вся информация в нем будут удалены. Удалить достижение?")
                                    }
                }
                Spacer()
                    .frame(height: 32)
                Spacer()
                SaveButton(canSave: !name.isEmpty)
                    .onTapGesture {
                        if !name.isEmpty {
                            cardSettings.achievements.append(AchievementModel(
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
            self.name = cardSettings.achievementIndex == -1 ? "" : cardSettings.achievements[cardSettings.achievementIndex].name
            self.description = cardSettings.achievementIndex == -1 ? "" : cardSettings.achievements[cardSettings.achievementIndex].description
            self.url = cardSettings.achievementIndex == -1 ? "" : cardSettings.achievements[cardSettings.achievementIndex].url
        }
        .onTapGesture {
            nameIsFocused = false
            descriptionIsFocused = false
            urlIsFocused = false
        }
    }
}
