import SwiftUI
import PhotosUI
import Combine

struct CardEditBody: View {
    @EnvironmentObject var viewModel: CardViewModel
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var isAchievement: Bool = false
    @State private var achievementName: String = ""
    @State private var achievementDescription: String = ""
    @State private var achievementUrl: String = ""
    
    @State private var isAlert: Bool = false

    @FocusState var jobTitleIsFocused: Bool
    
    @FocusState var specificityIsFocused: Bool
    
    @FocusState var firstNameIsFocused: Bool
    
    @FocusState var lastNameIsFocused: Bool
    
    @FocusState var phoneIsFocused: Bool
    
    @FocusState var emailIsFocused: Bool
    
    @FocusState var addressIsFocused: Bool
    
    @FocusState var telegramIsFocused: Bool
    
    @FocusState var vkIsFocused: Bool
    
    @FocusState var facebookIsFocused: Bool
    
    @FocusState var siteIsFocused: Bool
    
    @FocusState var cvIsFocused: Bool

    @FocusState var showLogoPicker: Bool
    
    @FocusState var bioIsFocused: Bool
    
    var body: some View {
        ZStack {
            if self.viewModel.pageType == .loading {
                VStack {
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
                    if self.viewModel.pageType == .loading {
                        ProgressView()
                    }
                    else {
                        VStack {
                            CardImageView(
                                image: $viewModel.avatarImage,
                                imageUrl: $viewModel.avatarUrl,
                                showButton: true
                            )
                            .frame(height: 360)
                            VStack (alignment: .leading) {
                                VStack (alignment: .leading) {
                                    CustomText(text: "Должность*")
                                    Spacer()
                                        .frame(height: 12)
                                    CustomTextField(
                                        value: $viewModel.jobTitle,
                                        hintText: "Введите должность",
                                        focused: $jobTitleIsFocused
                                    )
                                    .onTapGesture {
                                        jobTitleIsFocused = true
                                    }
                                    Spacer()
                                        .frame(height: 16)
                                    CustomText(text: "Специфика*")
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
                                            CustomTextField(
                                                value: $viewModel.specificity,
                                                hintText: "Выберите специфику",
                                                focused: $specificityIsFocused
                                            )
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(textSecondary)
                                                .offset(x: -20)
                                        }
                                    }
                                    Spacer()
                                        .frame(height: 16)
                                    CustomText(text: "Имя*")
                                    Spacer()
                                        .frame(height: 12)
                                    CustomTextField(
                                        value: $viewModel.firstName,
                                        hintText: "Введите имя",
                                        focused: $firstNameIsFocused
                                    )
                                    .onTapGesture {
                                        firstNameIsFocused = true
                                    }
                                    Spacer()
                                        .frame(height: 16)
                                    CustomText(text: "Фамилия*")
                                    Spacer()
                                        .frame(height: 12)
                                    CustomTextField(
                                        value: $viewModel.lastName,
                                        hintText: "Введите фамилию",
                                        focused: $lastNameIsFocused
                                    )
                                    .onTapGesture {
                                        lastNameIsFocused = true
                                    }
                                    Spacer()
                                        .frame(height: 16)
                                    CustomText(text: "Номер телефона")
                                    Spacer()
                                        .frame(height: 12)
                                    CustomTextField(
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
                                    CustomText(text: "Электронная почта*")
                                    Spacer()
                                        .frame(height: 12)
                                    CustomTextField(
                                        value: $viewModel.email,
                                        hintText: "Введите адрес эл. почты",
                                        focused: $emailIsFocused
                                    )
                                    .onTapGesture {
                                        emailIsFocused = true
                                    }
                                    Spacer()
                                        .frame(height: 16)
                                    CustomText(text: "Адрес")
                                    Spacer()
                                        .frame(height: 12)
                                    CustomTextField(
                                        value: $viewModel.address,
                                        hintText: "Введите коммерческий адрес",
                                        focused: $addressIsFocused
                                    )
                                    .onTapGesture {
                                        addressIsFocused = true
                                    }
                                    Spacer()
                                        .frame(height: 16)
                                    CustomText(text: "Telegram")
                                    Spacer()
                                        .frame(height: 12)
                                    CustomTextField(
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
                                    CustomText(text: "Вконтакте")
                                    Spacer()
                                        .frame(height: 12)
                                    CustomTextField(
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
                                    CustomText(text: "Facebook")
                                    Spacer()
                                        .frame(height: 12)
                                    CustomTextField(
                                        value: $viewModel.facebook,
                                        hintText: "Введите ссылку",
                                        focused: $facebookIsFocused
                                    )
                                    .onTapGesture {
                                        facebookIsFocused = true
                                    }
                                    .onChange(of: self.viewModel.facebook) {
                                        self.viewModel.onChangeFacebook()
                                    }
                                    Spacer()
                                        .frame(height: 16)
                                    CustomText(text: "Свой сайт")
                                    Spacer()
                                        .frame(height: 12)
                                    CustomTextField(
                                        value: $viewModel.site,
                                        hintText: "Вставьте ссылку",
                                        focused: $siteIsFocused
                                    )
                                    .onTapGesture {
                                        siteIsFocused = true
                                    }
                                    Spacer()
                                        .frame(height: 16)
                                    CustomText(text: "Резюме")
                                    Spacer()
                                        .frame(height: 12)
                                    CustomTextField(
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
                                    CustomText(text: "О себе")
                                    Spacer()
                                        .frame(height: 12)
                                    CustomTextField(
                                        value: $viewModel.bio,
                                        hintText: "Расскажите о себе",
                                        focused: $bioIsFocused,
                                        height: 177,
                                        limit: 800,
                                        isLongText: true
                                    )
                                    .lineLimit(8)
                                    .onTapGesture {
                                        bioIsFocused = true
                                    }
                                    Spacer()
                                        .frame(height: 16)
                                    CustomText(text: "Шаблон визитки")
                                    Spacer()
                                        .frame(height: 12)
                                    NavigationStack {
                                        CardTemplateView(cardModel: self.viewModel.cardModel)
                                            .onTapGesture {
                                                self.viewModel.openTemplates()
                                            }
                                            .navigationDestination(isPresented: $viewModel.templatesOpened) {
                                            TemplatesPageView()
                                                .environmentObject(self.viewModel)
                                        }
                                    }
                                    Spacer()
                                        .frame(height: 16)
                                    CustomText(text: "Услуги")
                                    Spacer()
                                        .frame(height: 12)
                                }
                                .padding([.horizontal], 20)
                                CardServicesTileView()
                                Spacer()
                                    .frame(height: 16)
                                CustomText(text: "Достижения")
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
                                        DeleteWidget(text: "визитку")
                                            .onTapGesture {
                                                isAlert.toggle()
                                            }
                                            .customAlert(
                                                "Удалить визитку?",
                                                isPresented: $isAlert,
                                                actionText: "Удалить"
                                            ) {
                                                self.viewModel.deleteCard()
                                            } message: {
                                                Text("Визитка и вся информация в ней будут удалены. Удалить визитку?")
                                            }
                                        Spacer()
                                            .frame(height: 32)
                                    }
                                    CustomButton(
                                        text: "Сохранить",
                                        color: !self.viewModel.jobTitle.isEmpty && !self.viewModel.specificity.isEmpty && !self.viewModel.firstName.isEmpty && !self.viewModel.lastName.isEmpty && !self.viewModel.email.isEmpty ? Color(
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
                                            self.viewModel.save()
                                        }
                                    Spacer()
                                        .frame(height: 74)
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
            }
        }
        .onTapGesture {
            jobTitleIsFocused = false
            specificityIsFocused = false
            firstNameIsFocused = false
            lastNameIsFocused = false
            phoneIsFocused = false
            emailIsFocused = false
            addressIsFocused = false
            telegramIsFocused = false
            vkIsFocused = false
            facebookIsFocused = false
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
