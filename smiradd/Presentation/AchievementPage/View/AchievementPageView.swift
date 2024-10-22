import SwiftUI

struct AchievementPageView: View {
    var index: Int = -1
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @EnvironmentObject private var navigationService: NavigationService
    
    @StateObject var viewModel: AchievementViewModel
    
    @FocusState private var nameIsFocused: Bool
    
    @FocusState private var descriptionIsFocused: Bool
    
    @FocusState private var urlIsFocused: Bool
    
    init(
        index: Int,
        commonViewModel: CommonViewModel
    ) {
        self.index = index
        
        _viewModel = StateObject(
            wrappedValue: AchievementViewModel(
                index: index,
                commonViewModel: commonViewModel
            )
        )
    }
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                CustomAppBarView(
                    title: self.index == -1
                    ? "Создание кейса"
                    : "Изменение кейса"
                )
                .padding(
                    [.vertical],
                    8
                )
                Spacer()
                    .frame(height: 20)
                CustomTextView(
                    text: "Название",
                    isRequired: true
                )
                Spacer()
                    .frame(height: 12)
                CustomTextFieldView(
                    value: self.$viewModel.name,
                    hintText: "Введите название кейса",
                    focused: self.$nameIsFocused,
                    limit: 30,
                    showCount: true
                )
                .onTapGesture {
                    self.nameIsFocused = true
                }
                Spacer()
                    .frame(height: 20)
                CustomTextView(text: "Описание")
                Spacer()
                    .frame(height: 12)
                CustomTextFieldView(
                    value: self.$viewModel.description,
                    hintText: "Кратко опишите кейс",
                    focused: self.$descriptionIsFocused,
                    height: 103,
                    limit: 80,
                    isLongText: true,
                    showCount: true
                )
                .lineLimit(5)
                .onTapGesture {
                    self.descriptionIsFocused = true
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
                CustomTextFieldView(
                    value: self.$viewModel.url,
                    hintText: "Вставьте ссылку",
                    focused: $urlIsFocused
                )
                .onTapGesture {
                    urlIsFocused = true
                }
                if self.index != -1 {
                    DeleteView(text: "кейс")
                        .onTapGesture {
                            self.viewModel.openDeleteAlert()
                        }
                        .customAlert(
                            "Удалить?",
                            isPresented: $viewModel.isAlert,
                            actionText: "Удалить"
                        ) {
                            self.commonViewModel.deleteAchievement(
                                index: self.index
                            )
                            
                            self.navigationService.navigateBack()
                        } message: {
                            Text(
                                "Кейс и вся информация в нем будут удалены. Удалить кейс?"
                            )
                        }
                }
                Spacer()
                    .frame(height: 32)
                Spacer()
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
                    ))
                .onTapGesture {
                    self.commonViewModel.saveAchievement(
                        index: self.index,
                        name: self.viewModel.name,
                        description: self.viewModel.description,
                        url: self.viewModel.url
                    )
                    
                    self.navigationService.navigateBack()
                }
                Spacer()
                    .frame(height: 74)
            }
            .padding(
                [.horizontal],
                20
            )
        }
        .navigationBarHidden(true)
        .background(.white)
        .onTapGesture {
            nameIsFocused = false
            descriptionIsFocused = false
            urlIsFocused = false
        }
    }
}
