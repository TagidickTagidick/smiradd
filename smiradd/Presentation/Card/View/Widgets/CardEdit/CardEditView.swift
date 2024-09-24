import SwiftUI
import PhotosUI
import Combine

struct CardEditView: View {
    @EnvironmentObject var viewModel: CardViewModel
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    @FocusState var jobTitleIsFocused: Bool
    
    @FocusState var specificityIsFocused: Bool
    
    @FocusState var nameIsFocused: Bool
    
    @FocusState var phoneIsFocused: Bool
    
    @FocusState var emailIsFocused: Bool
    
    @FocusState var addressIsFocused: Bool
    
    @FocusState var seekIsFocused: Bool
    
    @FocusState var usefulIsFocused: Bool
    
    @FocusState var telegramIsFocused: Bool
    
    @FocusState var vkIsFocused: Bool
    
    @FocusState var siteIsFocused: Bool
    
    @FocusState var cvIsFocused: Bool

    @FocusState var showLogoPicker: Bool
    
    @FocusState var bioIsFocused: Bool
    
    var body: some View {
        ScrollView {
            if self.viewModel.pageType == .loading {
                ProgressView()
            }
            else {
                VStack {
                    CardImageView(
                        image: $viewModel.avatarImage,
                        imageUrl: $viewModel.avatarUrl,
                        showTrailing: false,
                        editButton: false,
                        onTapEditButton: {
                            self.viewModel.cardType = .editCard
                        }
                    )
                    .frame(height: 360)
                    VStack (alignment: .leading) {
                        VStack (alignment: .leading) {
                            CustomTextView(
                                text: "Должность/статус",
                                isRequired: true
                            )
                            Spacer()
                                .frame(height: 12)
                            CustomTextFieldView(
                                value: $viewModel.jobTitle,
                                hintText: "Введите должность",
                                focused: $jobTitleIsFocused,
                                limit: 25,
                                showCount: true
                            )
                            .onTapGesture {
                                jobTitleIsFocused = true
                            }
                            Spacer()
                                .frame(height: 16)
                            CustomTextView(
                                text: "Отрасль",
                                isRequired: true
                            )
                            Menu {
                                ForEach(self.viewModel.specificityList) {
                                    specificityModel in
                                    Button(
                                        action: {
                                            self.viewModel.specificity = specificityModel.name
                                        }
                                    ) {
                                        Text(specificityModel.name)
                                    }
                                }
                            } label: {
                                ZStack (alignment: .trailing) {
                                    CustomTextFieldView(
                                        value: $viewModel.specificity,
                                        hintText: "Выберите отрасль",
                                        focused: $specificityIsFocused
                                    )
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(textSecondary)
                                        .offset(x: -20)
                                }
                            }
                            Spacer()
                                .frame(height: 16)
                            CustomTextView(
                                text: "Имя Фамилия",
                                isRequired: true
                            )
                            Spacer()
                                .frame(height: 12)
                            CustomTextFieldView(
                                value: $viewModel.name,
                                hintText: "Введите имя и фамилию",
                                focused: $nameIsFocused,
                                limit: 30,
                                showCount: true
                            )
                            .onTapGesture {
                                nameIsFocused = true
                            }
                            Spacer()
                                .frame(height: 16)
                            CustomTextView(
                                text: "Номер телефона",
                                isRequired: true
                            )
                            Spacer()
                                .frame(height: 12)
                            CustomTextFieldView(
                                value: $viewModel.phone,
                                hintText: "X (XXX) XXX-XX-XX",
                                focused: $phoneIsFocused,
                                limit: 17
                            )
                            .keyboardType(.numberPad)
                            .onTapGesture {
                                phoneIsFocused = true
                            }
                            .onChange(of: self.viewModel.phone) {
                                self.viewModel.onChangePhone()
                                
                                if (self.viewModel.phone.count == 17) {
                                    phoneIsFocused = false
                                }
                            }
                            Spacer()
                                .frame(height: 16)
                            CustomTextView(
                                text: "Электронная почта"
                            )
                            Spacer()
                                .frame(height: 12)
                            CustomTextFieldView(
                                value: $viewModel.email,
                                hintText: "example@mail.com",
                                focused: $emailIsFocused
                            )
                            .onChange(of: self.emailIsFocused) {
                                self.viewModel.checkEmail()
                            }
                            .onTapGesture {
                                emailIsFocused = true
                            }
                            if !self.viewModel.isValidEmail {
                                Spacer()
                                    .frame(
                                        height: 12
                                    )
                                Text("Адрес электронной почты не валиден")
                                .font(
                                    .custom(
                                        "OpenSans-Regular",
                                        size: 14
                                    )
                                )
                                .foregroundStyle(
                                    Color(
                                        red: 0.898,
                                        green: 0.271,
                                        blue: 0.267
                                    )
                                )
                            }
                            Spacer()
                                .frame(height: 16)
                            CustomTextView(text: "Ищу")
                            Spacer()
                                .frame(height: 12)
                            CustomTextFieldView(
                                value: $viewModel.seek,
                                hintText: "Кого или что вы ищете на форуме",
                                focused: $seekIsFocused,
                                height: 72,
                                limit: 50,
                                isLongText: true,
                                showCount: true
                            )
                            .lineLimit(3)
                            .onTapGesture {
                                seekIsFocused = true
                            }
                            Spacer()
                                .frame(height: 16)
                            CustomTextView(text: "Полезен")
                            Spacer()
                                .frame(height: 12)
                            CustomTextFieldView(
                                value: $viewModel.useful,
                                hintText: "Чем вы могли бы быть полезны другим усастникам",
                                focused: $usefulIsFocused,
                                height: 72,
                                limit: 50,
                                isLongText: true,
                                showCount: true
                            )
                            .lineLimit(3)
                            .onTapGesture {
                                usefulIsFocused = true
                            }
                            Spacer()
                                .frame(height: 16)
                            CustomTextView(text: "Город")
                            Spacer()
                                .frame(height: 12)
                            CustomTextFieldView(
                                value: $viewModel.address,
                                hintText: "Ваш город",
                                focused: $addressIsFocused
                            )
                            .onTapGesture {
                                addressIsFocused = true
                            }
                            Spacer()
                                .frame(height: 16)
                            CustomTextView(text: "Telegram")
                            Spacer()
                                .frame(height: 12)
                            CustomTextFieldView(
                                value: $viewModel.telegram,
                                hintText: "Введите ссылку",
                                focused: $telegramIsFocused
                            )
                            .onTapGesture {
                                telegramIsFocused = true
                            }
                            .onChange(of: self.viewModel.telegram) {
                                self.viewModel.onChangeTelegram()
                            }
                            Spacer()
                                .frame(height: 16)
                            CustomTextView(text: "Вконтакте")
                            Spacer()
                                .frame(height: 12)
                            CustomTextFieldView(
                                value: $viewModel.vk,
                                hintText: "Введите ссылку",
                                focused: $vkIsFocused
                            )
                            .onTapGesture {
                                vkIsFocused = true
                            }
                            .onChange(of: self.viewModel.vk) {
                                self.viewModel.onChangeVk()
                            }
                            Spacer()
                                .frame(height: 16)
                            CustomTextView(
                                text: "Доп. материалы"
                            )
                            Spacer()
                                .frame(height: 12)
                            CustomTextFieldView(
                                value: $viewModel.site,
                                hintText: "Оставьте дополнительную ссылку",
                                focused: $siteIsFocused
                            )
                            .onTapGesture {
                                siteIsFocused = true
                            }
                            Spacer()
                                .frame(height: 16)
                            CustomTextView(text: "Резюме")
                            Spacer()
                                .frame(height: 12)
                            CustomTextFieldView(
                                value: $viewModel.cv,
                                hintText: "Вставьте ссылку",
                                focused: $cvIsFocused
                            )
                            .onTapGesture {
                                cvIsFocused = true
                            }
                            Spacer()
                                .frame(height: 16)
                            CardLogoView(
                                image: $viewModel.logoImage,
                                imageUrl: $viewModel.logoUrl
                            )
                            Spacer()
                                .frame(width: 16)
                            CustomTextView(text: "О себе")
                            Spacer()
                                .frame(height: 12)
                            CustomTextFieldView(
                                value: $viewModel.bio,
                                hintText: "Расскажите о себе",
                                focused: $bioIsFocused,
                                height: 177,
                                limit: 500,
                                isLongText: true,
                                showCount: true
                            )
                            .lineLimit(8)
                            .onTapGesture {
                                bioIsFocused = true
                            }
                            Spacer()
                                .frame(height: 16)
                            CustomTextView(
                                text: "Шаблон визитки"
                            )
                            Spacer()
                                .frame(height: 12)
                            CardTemplateView(
                                cardModel: self.viewModel.cardModel
                            )
                                .onTapGesture {
                                    self.viewModel.openTemplates()
                                }
                                .navigationDestination(
                                    isPresented: $viewModel.templatesOpened
                                ) {
                                TemplatesPageView()
                                    .environmentObject(self.viewModel)
                            }
                            Spacer()
                                .frame(height: 16)
                            CustomTextView(text: "Услуги")
                            Spacer()
                                .frame(height: 12)
                        }
                        .padding([.horizontal], 20)
                        CardServicesTileView()
                        Spacer()
                            .frame(height: 16)
                        CustomTextView(text: "Достижения")
                            .padding(
                                [.horizontal],
                                20
                            )
                        Spacer()
                            .frame(height: 12)
                        CardAchievementsTileView()
                        Spacer()
                            .frame(height: 32)
                        VStack (alignment: .leading) {
                            if self.viewModel.cardType == .editCard {
                                DeleteView(text: "визитку")
                                    .onTapGesture {
                                        self.viewModel.openAlert()
                                    }
                                    .customAlert(
                                        "Удалить визитку?",
                                        isPresented: $viewModel.isAlert,
                                        actionText: "Удалить"
                                    ) {
                                        self.viewModel.deleteCard()
                                    } message: {
                                        Text("Визитка и вся информация в ней будут удалены. Удалить визитку?")
                                    }
                                Spacer()
                                    .frame(height: 32)
                            }
                            CustomButtonView(
                                text: "Сохранить",
                                color: self.viewModel.isValidButton
                                ? Color(
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
                                    height: 74 + safeAreaInsets.bottom
                                )
                        }
                        .padding(
                            [.horizontal],
                            20
                        )
                    }
                    .padding([.vertical], 16)
                }
            }
        }
        .onTapGesture {
            jobTitleIsFocused = false
            specificityIsFocused = false
            nameIsFocused = false
            phoneIsFocused = false
            emailIsFocused = false
            addressIsFocused = false
            seekIsFocused = false
            usefulIsFocused = false
            telegramIsFocused = false
            vkIsFocused = false
            siteIsFocused = false
            cvIsFocused = false
            bioIsFocused = false
        }
        .onAppear {
            //            cardSettings.achievements.append(AchievementModel(name: "ырыррsjsbjjs", description: "вырыррыdsbhhbdbhdhbdhbdhbdhbdhbhbdhbdhbdhbdhbdbdbhbdhbhdbhhbdbhdhbdhbhbdhbdhbdhbhdbhbdhbdhbdhbhbd", url: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Earth_from_Space.jpg/1200px-Earth_from_Space.jpg"))
//            makeRequest(path: "specifity", method: .get) { (result: Result<[SpecificityModel], Error>) in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let specificityList):
//                        self.specificityList = specificityList
//                        self.pageType = .matchNotFound
//                    case .failure(let error):
//                        if error.localizedDescription == "The Internet connection appears to be offline." {
//                            self.pageType = .noResultsFound
//                        }
//                        else {
//                            self.pageType = .somethingWentWrong
//                        }
//                        print(error.localizedDescription)
//                    }
//                }
//            }
        }
    }
}
