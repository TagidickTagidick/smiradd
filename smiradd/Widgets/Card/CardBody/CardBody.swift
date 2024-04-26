import SwiftUI
import PhotosUI
import Combine

struct CardBody: View {
    @EnvironmentObject var router: Router
    
    @State private var pageType: PageType = .loading
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var avatarUrl: String = ""
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var showAvatarPicker: Bool = false
    @State private var showAvatarCamera: Bool = false
    @State private var avatarUIImage: UIImage?
    
    @State private var jobTitle: String = ""
    @FocusState private var jobTitleIsFocused: Bool
    
    @State private var specificity: String = ""
    @FocusState private var specificityIsFocused: Bool
    @State private var specificityList: [SpecificityModel] = []
    
    @State private var firstName: String = ""
    @FocusState private var firstNameIsFocused: Bool
    
    @State private var lastName: String = ""
    @FocusState private var lastNameIsFocused: Bool
    
    @State private var oldPhone: String = ""
    @State private var phone: String = ""
    @FocusState private var phoneIsFocused: Bool
    
    @State private var email: String = ""
    @FocusState private var emailIsFocused: Bool
    
    @State private var address: String = ""
    @FocusState private var addressIsFocused: Bool
    
    @State private var telegram: String = "https://t.me/"
    @FocusState private var telegramIsFocused: Bool
    
    @State private var vk: String = "https://vk.com/"
    @FocusState private var vkIsFocused: Bool
    
    @State private var facebook: String = "https://www.facebook.com/"
    @FocusState private var facebookIsFocused: Bool
    
    @State private var site: String = ""
    @FocusState private var siteIsFocused: Bool
    
    @State private var cv: String = ""
    @FocusState private var cvIsFocused: Bool
    
    @State private var logoUrl: String = ""
    @State private var logoItem: PhotosPickerItem?
    @State private var logoImage: Image?
    @State private var showLogoPicker: Bool = false
    @State private var showLogoCamera: Bool = false
    @State private var logoUIImage: UIImage?
    
    @State private var about: String = ""
    @FocusState private var aboutIsFocused: Bool
    
    @State private var isAchievement: Bool = false
    @State private var achievementName: String = ""
    @State private var achievementDescription: String = ""
    @State private var achievementUrl: String = ""
    
    @EnvironmentObject var cardSettings: CardSettings
    
    var body: some View {
        ZStack {
            if pageType == .loading {
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
                    if pageType == .loading {
                        ProgressView()
                    }
                    else {
                        VStack {
                            ZStack {
        //                        AsyncImage(url: URL(string: "https://s3.timeweb.cloud/29ad2e34-vizme/048abfb81af643bc84ec8b6dc9e6ea72.webp")) { image in
        //                            image
        //                                .resizable()
        //                                .aspectRatio(contentMode: .fit)
        //                                .frame(height: 200) // Set your desired height here
        //                        } placeholder: {
        //                            // Placeholder view or activity indicator can be added here
        //                            ProgressView()
        //                        }
                                //https://s3.timeweb.cloud/29ad2e34-vizme/048abfb81af643bc84ec8b6dc9e6ea72.webp
                                if avatarUIImage == nil {
                                    if avatarImage == nil {
                                        Image("avatar")
                                    }
                                    else {
                                        avatarImage?
                                            .resizable()
                                            .frame(
                                                width: UIScreen.main.bounds.width,
                                                height: 360
                                                )
                                    }
                                }
                                else {
                                    Image(uiImage: avatarUIImage!)
                                        .resizable()
                                        .frame(
                                            width: UIScreen.main.bounds.width,
                                            height: 360
                                            )
                                }
                                VStack {
                                    Spacer()
                                        .frame(height: safeAreaInsets.top)
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .fill(.white.opacity(0.4))
                                                .frame(
                                                    width: 48,
                                                    height: 48
                                                )
                                            Image(systemName: "arrow.left")
                                                .foregroundColor(textDefault)
                                        }
                                        .onTapGesture {
                                            router.navigateBack()
                                        }
                                        Spacer()
                                        ZStack {
                                            Circle()
                                                .fill(.white.opacity(0.4))
                                                .frame(
                                                    width: 48,
                                                    height: 48
                                                )
                                            Image("unlock")
                                                .foregroundColor(Color(
                                                    red: 0.8,
                                                    green: 0.8,
                                                    blue: 0.8
                                                ))
                                        }
                                    }
                                    Spacer()
                                    if cardSettings.cardType == .myCard {
                                        ZStack {
                                            HStack {
                                                Image("edit")
                                                Spacer()
                                                    .frame(width: 10)
                                                Text("Редактировать")
                                                    .font(
                                                        .custom(
                                                            "OpenSans-SemiBold",
                                                            size: 16
                                                        )
                                                    )
                                                    .foregroundStyle(textDefault)
                                            }
                                            .frame(
                                                minWidth: UIScreen.main.bounds.width - 40,
                                                minHeight: 48
                                            )
                                            .background(.white.opacity(0.4))
                                            .cornerRadius(28)
                                        }
                                        .onTapGesture {
                                            cardSettings.cardType = .editCard
                                        }
                                    }
                                }
                                .padding([.vertical, .horizontal], 20)
                            }
                            .frame(height: 360)
                            VStack (alignment: .leading) {
                                CustomText(text: "Должность*")
                                Spacer()
                                    .frame(height: 12)
                                CustomTextField(
                                    value: $jobTitle,
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
                                    ForEach(specificityList) { specificityModel in
                                        Button(action: {
                                            specificity = specificityModel.name
                                        }) {
                                            Text(specificityModel.name)
                                            }
                                        }
                                        } label: {
                                            ZStack (alignment: .trailing) {
                                                CustomTextField(
                                                    value: $specificity,
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
                                    value: $firstName,
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
                                    value: $lastName,
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
                                    value: $phone,
                                    hintText: "X (XXX) XXX-XX-XX",
                                    focused: $phoneIsFocused,
                                    limit: 17
                                )
                                .keyboardType(.numberPad)
                                .onTapGesture {
                                    phoneIsFocused = true
                                }
                                .onChange(of: phone) {
                                    if oldPhone.count < phone.count {
                                        if oldPhone.count == 1 {
                                            let indexToAdd = phone.index(before: phone.index(
                                                phone.endIndex,
                                                offsetBy: 0
                                            ))
                                            phone.insert(contentsOf: " (", at: indexToAdd)
                                        }
                                        if oldPhone.count == 6 {
                                            let indexToAdd = phone.index(before: phone.index(
                                                phone.endIndex,
                                                offsetBy: 0
                                            ))
                                            phone.insert(contentsOf: ") ", at: indexToAdd)
                                        }
                                        if oldPhone.count == 11 || phone.count == 15 {
                                            let indexToAdd = phone.index(before: phone.index(
                                                phone.endIndex,
                                                offsetBy: 0
                                            ))
                                            phone.insert(contentsOf: "-", at: indexToAdd)
                                        }
                                    }
                                    else {
                                        if phone.count == 15 || phone.count == 12 {
                                            phone.removeLast()
                                        }
                                        if phone.count == 8 || phone.count == 3 {
                                            phone.removeLast()
                                            phone.removeLast()
                                        }
                                    }
                                    oldPhone = phone
                                    
                                    if phone.count == 17 {
                                        phoneIsFocused = false
                                    }
                                }
                                Spacer()
                                    .frame(height: 16)
                                CustomText(text: "Электронная почта*")
                                Spacer()
                                    .frame(height: 12)
                                CustomTextField(
                                    value: $email,
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
                                    value: $address,
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
                                    value: $telegram,
                                    hintText: "Введите ссылку",
                                    focused: $telegramIsFocused
                                )
                                .onTapGesture {
                                    telegramIsFocused = true
                                }
                                .onChange(of: telegram) {
                                    if telegram.count < 13 {
                                        telegram = "https://t.me/"
                                    }
                                }
                                Spacer()
                                    .frame(height: 16)
                                CustomText(text: "Вконтакте")
                                Spacer()
                                    .frame(height: 12)
                                CustomTextField(
                                    value: $vk,
                                    hintText: "Введите ссылку",
                                    focused: $vkIsFocused
                                )
                                .onTapGesture {
                                    vkIsFocused = true
                                }
                                .onChange(of: vk) {
                                    if vk.count < 15 {
                                        vk = "https://vk.com/"
                                    }
                                }
                                Spacer()
                                    .frame(height: 16)
                                CustomText(text: "Facebook")
                                Spacer()
                                    .frame(height: 12)
                                CustomTextField(
                                    value: $facebook,
                                    hintText: "Введите ссылку",
                                    focused: $facebookIsFocused
                                )
                                .onTapGesture {
                                    facebookIsFocused = true
                                }
                                .onChange(of: facebook) {
                                    if facebook.count < 25 {
                                        facebook = "https://www.facebook.com/"
                                    }
                                }
                                Spacer()
                                    .frame(height: 16)
                                CustomText(text: "Свой сайт")
                                Spacer()
                                    .frame(height: 12)
                                CustomTextField(
                                    value: $site,
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
                                    value: $cv,
                                    hintText: "Вставьте ссылку",
                                    focused: $cvIsFocused
                                )
                                .onTapGesture {
                                    cvIsFocused = true
                                }
                                Spacer()
                                    .frame(height: 16)
                                HStack {
                                    Menu {
                                        Button("Сделать снимок", action: {
                                            self.showLogoCamera.toggle()
                                        })
                                        Button("Выбрать из галереи", action: {
                                            self.showLogoPicker = true
                                        })
                                            } label: {
                                                if logoUIImage == nil {
                                                    if logoImage == nil {
                                                        ZStack {
                                                            Image(systemName: "plus")
                                                                .frame(
                                                                    width: 36,
                                                                    height: 36
                                                                )
                                                                .foregroundStyle(textAdditional)
                                                        }
                                                        .frame(
                                                            width: 80,
                                                            height: 80
                                                        )
                                                        .background(accent50)
                                                        .cornerRadius(16)
                                                    }
                                                    else {
                                                        logoImage?
                                                            .resizable()
                                                            .frame(
                                                                width: 80,
                                                                height: 80
                                                            )
                                                            .cornerRadius(16)
                                                    }
                                                }
                                                else {
                                                    Image(uiImage: logoUIImage!)
                                                        .resizable()
                                                        .frame(
                                                            width: 80,
                                                            height: 80
                                                        )
                                                        .cornerRadius(16)
                                                }
                                            }
                                            .fullScreenCover(isPresented: self.$showLogoCamera) {
                                                accessCameraView(selectedImage: self.$logoUIImage)
                                                    .edgesIgnoringSafeArea(.all)
                                            }
                                            .photosPicker(isPresented: $showLogoPicker, selection: $logoItem)
                                            .onChange(of: logoItem) {
                                                Task {
                                                    if let loaded = try? await logoItem?.loadTransferable(type: Image.self) {
                                                        logoImage = loaded
                                                        logoUIImage = nil
                                                    } else {
                                                        print("Failed")
                                                    }
                                                }
                                            }
                                    Spacer()
                                        .frame(width: 16)
                                    Menu {
                                        Button("Сделать снимок", action: {
                                            self.showLogoCamera.toggle()
                                        })
                                        Button("Выбрать из галереи", action: {
                                            self.showLogoPicker = true
                                        })
                                            } label: {
                                                HStack {
                                                    Image("edit")
                                                    Spacer()
                                                        .frame(width: 8)
                                                    Text("Изменить логотип")
                                                        .font(
                                                            .custom(
                                                                "OpenSans-SemiBold",
                                                                size: 18
                                                            )
                                                        )
                                                        .foregroundStyle(textDefault)
                                                }
                                                .frame(
                                                    minWidth: UIScreen.main.bounds.width - 152,
                                                    minHeight: 48
                                                )
                                                .background(accent50)
                                                .cornerRadius(24)
                                            }
                                }
                                Spacer()
                                    .frame(width: 16)
                                CustomText(text: "О себе")
                                Spacer()
                                    .frame(height: 12)
                                CustomTextField(
                                    value: $about,
                                    hintText: "Расскажите о себе",
                                    focused: $aboutIsFocused,
                                    height: 177,
                                    limit: 800,
                                    isLongText: true
                                )
                                .lineLimit(8)
                                .onTapGesture {
                                    aboutIsFocused = true
                                }
                                Spacer()
                                    .frame(height: 16)
                                CustomText(text: "Шаблон визитки")
                                Spacer()
                                    .frame(height: 12)
                                CardTemplate()
                                Spacer()
                                    .frame(height: 16)
                                CustomText(text: "Услуги")
                                Spacer()
                                    .frame(height: 12)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ZStack {
                                            Image(systemName: "plus")
                                                .frame(
                                                    width: 36,
                                                    height: 36
                                                )
                                                .foregroundStyle(textAdditional)
                                        }
                                        .frame(
                                            width: 160,
                                            height: 192
                                        )
                                        .background(accent50)
                                        .cornerRadius(16)
                                        .onTapGesture {
                                            cardSettings.serviceIndex = -1
                                            router.navigate(to: .serviceScreen)
                                        }
                                        Spacer()
                                            .frame(width: 12)
                                        ForEach(Array(cardSettings.services.enumerated()), id: \.offset) { index, service in
                                            ZStack {
                                                ZStack (alignment: .topTrailing) {
                                                    AsyncImage(
                                                        url: URL(
                                                            string: service.coverUrl
                                                        )
                                                    ) { image in
                                                        image.resizable()
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                    VStack (alignment: .trailing) {
                                                        if service.price != 0 {
                                                            ZStack {
                                                                Text(String(service.price))
                                                                    .font(
                                                                        .custom(
                                                                            "OpenSans-SemiBold",
                                                                            size: 16
                                                                        )
                                                                    )
                                                                    .foregroundStyle(.white)
                                                            }
                                                            .padding(
                                                                [.vertical],
                                                                8
                                                            )
                                                            .padding(
                                                                [.horizontal],
                                                                20
                                                            )
                                                            .background(textDefault.opacity(0.8))
                                                            .cornerRadius(12)
                                                            .offset(x: -16, y: 16)
                                                        }
                                                        Spacer()
                                                        VStack (alignment: .leading) {
                                                            Text(service.name)
                                                                .font(
                                                                    .custom(
                                                                        "OpenSans-SemiBold",
                                                                        size: 16
                                                                    )
                                                                )
                                                                .foregroundStyle(.white)
                                                            Spacer()
                                                                .frame(height: 8)
                                                            Text(service.description)
                                                                .font(
                                                                    .custom(
                                                                        "OpenSans-Regular",
                                                                        size: 14
                                                                    )
                                                                )
                                                                .foregroundStyle(.white)
                                                        }
                                                        .padding(
                                                            [.vertical, .horizontal],
                                                            16
                                                        )
                                                        .frame(
                                                            width: 240,
                                                            height: 92
                                                        )
                                                        .background(textDefault.opacity(0.8))
                                                    }
                                                }
                                                .frame(
                                                    width: 240,
                                                    height: 192
                                                )
                                                .cornerRadius(12)
                                                ZStack {
                                                    HStack {
                                                        Image("edit")
                                                        Spacer()
                                                            .frame(width: 8)
                                                        Text("Изменить")
                                                            .font(
                                                                .custom(
                                                                    "OpenSans-SemiBold",
                                                                    size: 16
                                                                )
                                                            )
                                                            .foregroundStyle(textDefault)
                                                    }
                                                }
                                                .padding(
                                                    [.vertical],
                                                    9
                                                )
                                                .padding(
                                                    [.horizontal],
                                                    20
                                                )
                                                .background(.white.opacity(0.6))
                                                .cornerRadius(24)
                                            }
                                            .onTapGesture {
                                                cardSettings.serviceIndex = index
                                                router.navigate(to: .serviceScreen)
                                            }
                                        }
                                    }
                                }
                                Spacer()
                                    .frame(height: 16)
                                CustomText(text: "Достижения")
                                Spacer()
                                    .frame(height: 12)
                                ScrollView(
                                    .horizontal,
                                    showsIndicators: false
                                ) {
                                    HStack {
                                        ZStack {
                                            Image(systemName: "plus")
                                                .frame(
                                                    width: 36,
                                                    height: 36
                                                )
                                                .foregroundStyle(textAdditional)
                                        }
                                        .frame(
                                            width: 160,
                                            height: 160
                                        )
                                        .background(accent50)
                                        .cornerRadius(16)
                                        .onTapGesture {
                                            cardSettings.achievementIndex = -1
                                            router.navigate(to: .achievementScreen)
                                        }
                                        Spacer()
                                            .frame(width: 12)
                                        ForEach(Array(cardSettings.achievements.enumerated()), id: \.offset) {
                                            index, achievement in
                                            ZStack (alignment: .topLeading) {
                                                textDefault
                                                VStack (alignment: .leading) {
                                                    Text(achievement.name)
                                                        .font(
                                                            .custom(
                                                                "OpenSans-SemiBold",
                                                                size: 16
                                                            )
                                                        )
                                                        .foregroundStyle(.white)
                                                    Spacer()
                                                        .frame(height: 8)
                                                    Text(achievement.description)
                                                        .font(
                                                            .custom(
                                                                "OpenSans-Regular",
                                                                size: 14
                                                            )
                                                        )
                                                        .foregroundStyle(.white)
                                                }
                                            }
                                            .padding(
                                                [.vertical, .horizontal],
                                                16
                                            )
                                            .background(textDefault)
                                            .frame(
                                                width: 240,
                                                height: 160
                                            )
                                            .cornerRadius(12)
                                            .onTapGesture {
                                                cardSettings.achievementIndex = index
                                                router.navigate(to: .achievementScreen)
                                            }
                                        }
                                    }
                                }
                                Spacer()
                                    .frame(height: 32)
                                SaveButton(canSave: !jobTitle.isEmpty && !specificity.isEmpty && !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty)
                                    .onTapGesture {
                                        let body: [String: String] = [
                                            "job_title": jobTitle,
                                            "specificity": specificity,
                                            "name": firstName + " " + lastName,
                                            "email": email
                                        ]
                                        let finalBody = try! JSONSerialization.data(withJSONObject: body)
                                        makeRequest(path: "cards", method: .post, body: finalBody) { (result: Result<CardModel, Error>) in
                                            DispatchQueue.main.async {
                                                switch result {
                                                case .success(let profileModel):
                                                    print("success")
                                                case .failure(let error):
                                                    if error.localizedDescription == "The Internet connection appears to be offline." {
                                                        self.pageType = .internetError
                                                    }
                                                    else {
                                                        self.pageType = .nothingHere
                                                    }
                                                    print(error.localizedDescription)
                                                }
                                            }
                                        }
                                    }
                                Spacer()
                                    .frame(height: 74)
                            }
                            .padding([.horizontal], 20)
                            .padding([.vertical], 16)
                        }
                    }
                }
            }
        }
        .background(.white)
        .lazyPop()
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
            aboutIsFocused = false
        }
        .onAppear {
            cardSettings.achievements.append(AchievementModel(name: "ырыррsjsbjjs", description: "вырыррыdsbhhbdbhdhbdhbdhbdhbdhbhbdhbdhbdhbdhbdbdbhbdhbhdbhhbdbhdhbdhbhbdhbdhbdhbhdbhbdhbdhbdhbhbd", url: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Earth_from_Space.jpg/1200px-Earth_from_Space.jpg"))
            makeRequest(path: "specifity", method: .get) { (result: Result<[SpecificityModel], Error>) in
                switch result {
                case .success(let specificityList):
                    self.specificityList = specificityList
                    self.pageType = .nothingHere
                case .failure(let error):
                    if error.localizedDescription == "The Internet connection appears to be offline." {
                        self.pageType = .internetError
                    }
                    else {
                        self.pageType = .nothingHere
                    }
                    print(error.localizedDescription)
                }
            }
        }
    }
}
