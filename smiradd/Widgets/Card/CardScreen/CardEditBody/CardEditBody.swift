import SwiftUI
import PhotosUI
import Combine

struct CardEditBody: View {
    @EnvironmentObject var router: Router
    
    @State private var pageType: PageType = .loading
    
    @EnvironmentObject var cardSettings: CardSettings
    
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
    
    @State private var bio: String = ""
    @FocusState private var bioIsFocused: Bool
    
    @State private var isAchievement: Bool = false
    @State private var achievementName: String = ""
    @State private var achievementDescription: String = ""
    @State private var achievementUrl: String = ""
    
    @State private var isAlert: Bool = false
    
    func saveAvatar() {
        if (!avatarUrl.isEmpty
            || avatarImage != nil
            || avatarUIImage != nil
              ) {
            if avatarUIImage == nil {
                if !avatarUrl.isEmpty {
                    saveLogo()
                }
                
                if avatarImage != nil {
                    self.pageType = .loading
                    uploadImageToServer(image: avatarImage!) {
                        (result: Result<DetailsModel, Error>) in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let detailsModel):
                                self.avatarUrl = "https://s3.timeweb.cloud/29ad2e34-vizme/\(detailsModel.details)"
                                print("success")
                                saveLogo()
                            case .failure(let error):
                                if error.localizedDescription == "The Internet connection appears to be offline." {
                                    self.pageType = .internetError
                                }
                                else {
                                    self.pageType = .matchNotFound
                                }
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }
            else {
                self.pageType = .loading
                uploadUIImageToServer(image: avatarUIImage!) {
                    (result: Result<DetailsModel, Error>) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let detailsModel):
                            self.avatarUrl = "https://s3.timeweb.cloud/29ad2e34-vizme/\(detailsModel.details)"
                            saveLogo()
                        case .failure(let error):
                            if error.localizedDescription == "The Internet connection appears to be offline." {
                                self.pageType = .internetError
                            }
                            else {
                                self.pageType = .matchNotFound
                            }
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        else {
            saveLogo()
        }
    }
    
    func saveLogo() {
        if (!logoUrl.isEmpty
            || logoImage != nil
            || logoUIImage != nil
              ) {
            if logoUIImage == nil {
                if !logoUrl.isEmpty {
                    save()
                }
                
                if logoImage != nil {
                    self.pageType = .loading
                    uploadImageToServer(image: logoImage!) {
                        (result: Result<DetailsModel, Error>) in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let detailsModel):
                                self.logoUrl = "https://s3.timeweb.cloud/29ad2e34-vizme/\(detailsModel.details)"
                                save()
                            case .failure(let error):
                                if error.localizedDescription == "The Internet connection appears to be offline." {
                                    self.pageType = .internetError
                                }
                                else {
                                    self.pageType = .matchNotFound
                                }
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }
            else {
                self.pageType = .loading
                uploadUIImageToServer(image: logoUIImage!) {
                    (result: Result<DetailsModel, Error>) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let detailsModel):
                            self.logoUrl = "https://s3.timeweb.cloud/29ad2e34-vizme/\(detailsModel.details)"
                            save()
                        case .failure(let error):
                            if error.localizedDescription == "The Internet connection appears to be offline." {
                                self.pageType = .internetError
                            }
                            else {
                                self.pageType = .matchNotFound
                            }
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        else {
            save()
        }
    }
    
    func save() {
        let achievementsDict = cardSettings.achievements.map { achievement in
            return [
                "id": achievement.id,
                "name": achievement.name,
                "description": achievement.description,
                "url": achievement.url
            ]
        }
        
        let servicesDict = cardSettings.services.map { service in
            return [
                "name": service.name,
                "description": service.description,
                "price": service.price,
                "cover_url": service.coverUrl
            ]
        }

        var body: [String: Any?] = [
            "job_title": jobTitle,
            "specificity": specificity,
            "name": firstName + " " + lastName,
            "email": email,
            "achievements": achievementsDict,
            "services": servicesDict
        ]
        
        if !phone.isEmpty {
            body["phone"] = "+" + phone
        }
        
        if !address.isEmpty {
            body["address"] = address
        }
        
        if telegram.count != 13 {
            body["tg_url"] = telegram
        }
        
        if vk.count != 15 {
            body["vk_url"] = vk
        }
        
        if facebook.count != 25 {
            body["fb_url"] = facebook
        }
        
        if !site.isEmpty {
            body["seek"] = site
        }
        
        if !cv.isEmpty {
            body["cv_url"] = cv
        }
        
        if !bio.isEmpty {
            body["bio"] = bio
        }
        
        if !cardSettings.bcTemplateType.isEmpty {
            body["bc_template_type"] = cardSettings.bcTemplateType
        }
        
        if !avatarUrl.isEmpty {
            body["avatar_url"] = avatarUrl
        }
        
        if !logoUrl.isEmpty {
            body["company_logo"] = logoUrl
        }
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        if cardSettings.cardType == .editCard {
            makeRequest(
                path: "cards/\(cardSettings.cardId)",
                method: .patch,
                body: finalBody
            ) { (result: Result<CardModel, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        router.navigateBack()
                        print("success")
                    case .failure(let error):
                        if error.localizedDescription == "The Internet connection appears to be offline." {
                            self.pageType = .internetError
                        }
                        else {
                            self.pageType = .matchNotFound
                        }
                        print(error.localizedDescription)
                    }
                }
            }
        }
        else {
            makeRequest(path: "cards", method: .post, body: finalBody) { (result: Result<CardModel, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        router.navigateBack()
                        print("success")
                    case .failure(let error):
                        if error.localizedDescription == "The Internet connection appears to be offline." {
                            self.pageType = .internetError
                        }
                        else {
                            self.pageType = .matchNotFound
                        }
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
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
                                if avatarUIImage == nil {
                                    if !avatarUrl.isEmpty {
                                        AsyncImage(
                                            url: URL(
                                                string: avatarUrl
                                            )
                                        ) { image in
                                            image
                                                .resizable()
                                                .frame(
                                                    width: UIScreen.main.bounds.width,
                                                    height: 360
                                                    )
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
                                    else if avatarImage != nil {
                                        avatarImage?
                                            .resizable()
                                            .frame(
                                                width: UIScreen.main.bounds.width,
                                                height: 360
                                                )
                                    }
                                    else {
                                        Image("avatar")
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
                                        BackButton()
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
                                    Menu {
                                        Button("Сделать снимок", action: {
                                            self.showAvatarCamera.toggle()
                                        })
                                        Button("Выбрать из галереи", action: {
                                            self.showAvatarPicker = true
                                        })
                                            } label: {
                                                ZStack {
                                                    HStack {
                                                        Image("edit")
                                                        Spacer()
                                                            .frame(width: 10)
                                                        Text("Загрузить фотографию")
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
                                            }
                                            .fullScreenCover(isPresented: self.$showAvatarCamera) {
                                                accessCameraView(selectedImage: self.$avatarUIImage)
                                                    .edgesIgnoringSafeArea(.all)
                                            }
                                            .photosPicker(isPresented: $showAvatarPicker, selection: $avatarItem)
                                            .onChange(of: avatarItem) {
                                                Task {
                                                    if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                                                        avatarImage = loaded
                                                        avatarUIImage = nil
                                                    } else {
                                                        print("Failed")
                                                    }
                                                }
                                            }
                                }
                                .padding([.vertical, .horizontal], 20)
                            }
                            .frame(height: 360)
                            VStack (alignment: .leading) {
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
                                        value: $bio,
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
                                    CardTemplate()
                                    Spacer()
                                        .frame(height: 16)
                                    CustomText(text: "Услуги")
                                    Spacer()
                                        .frame(height: 12)
                                }
                                .padding([.horizontal], 20)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        Spacer()
                                            .frame(width: 20)
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
                                                CardService(service: service)
                                                ZStack {
                                                    HStack {
                                                        Image("edit")
                                                        Spacer()
                                                            .frame(width: 10)
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
                                    .padding(
                                        [.horizontal],
                                        20
                                    )
                                Spacer()
                                    .frame(height: 12)
                                ScrollView(
                                    .horizontal,
                                    showsIndicators: false
                                ) {
                                    HStack {
                                        Spacer()
                                            .frame(width: 20)
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
                                            index,
                                            achievement in
                                            ZStack {
                                                CardAchievement(achievement: achievement)
                                                ZStack {
                                                    HStack {
                                                        Image("edit")
                                                        Spacer()
                                                            .frame(width: 10)
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
                                                cardSettings.achievementIndex = index
                                                router.navigate(to: .achievementScreen)
                                            }
                                        }
                                    }
                                }
                                Spacer()
                                    .frame(height: 32)
                                VStack (alignment: .leading) {
                                    if cardSettings.cardType == .editCard {
                                        DeleteWidget(text: "визитку")
                                            .onTapGesture {
                                                isAlert.toggle()
                                            }
                                            .customAlert(
                                                            "Удалить визитку?",
                                                            isPresented: $isAlert,
                                                            actionText: "Удалить"
                                                        ) {
                                                            makeRequest(
                                                                path: "cards/\(cardSettings.cardModel.id)",
                                                                method: .delete,
                                                                isString: true
                                                            ) { (result: Result<DeleteModel, Error>) in
                                                                DispatchQueue.main.async {
                                                                    switch result {
                                                                    case .success(_):
                                                                        router.navigateBack()
                                                                        print("success")
                                                                    case .failure(let error):
                                                                        if error.localizedDescription == "The Internet connection appears to be offline." {
                                                                            self.pageType = .internetError
                                                                        }
                                                                        else {
                                                                            self.pageType = .matchNotFound
                                                                        }
                                                                        print(error.localizedDescription)
                                                                    }
                                                                }
                                                            }
                                                        } message: {
                                                            Text("Визитка и вся информация в ней будут удалены. Удалить визитку?")
                                                        }
                                        Spacer()
                                            .frame(height: 32)
                                    }
                                    
                                    SaveButton(canSave: !jobTitle.isEmpty && !specificity.isEmpty && !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty)
                                        .onTapGesture {
                                            if !jobTitle.isEmpty && !specificity.isEmpty && !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty {
                                                saveAvatar()
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
            if cardSettings.cardType == .editCard {
                jobTitle = cardSettings.cardModel.job_title
                specificity = cardSettings.cardModel.specificity
                firstName = cardSettings.cardModel.name.split(separator: " ").first!.description
                lastName = cardSettings.cardModel.name.split(separator: " ").last!.description
                phone = cardSettings.cardModel.phone == nil
                ? ""
                : CustomFormatter.formatPhoneNumber(cardSettings.cardModel.phone!)
                email = cardSettings.cardModel.email
                address = cardSettings.cardModel.address ?? ""
                telegram = cardSettings.cardModel.tg_url ?? "https://t.me/"
                vk = cardSettings.cardModel.vk_url ?? "https://vk.com/"
                facebook = cardSettings.cardModel.fb_url ?? "https://www.facebook.com/"
                site = cardSettings.cardModel.seek ?? ""
                cv = cardSettings.cardModel.cv_url ?? ""
                bio = cardSettings.cardModel.bio ?? ""
                avatarUrl = cardSettings.cardModel.avatar_url ?? ""
                if cardSettings.services.isEmpty {
                    cardSettings.services = cardSettings.cardModel.services ?? []
                }
                if cardSettings.achievements.isEmpty {
                    cardSettings.achievements = cardSettings.cardModel.achievements ?? []
                }
            }
//            cardSettings.achievements.append(AchievementModel(name: "ырыррsjsbjjs", description: "вырыррыdsbhhbdbhdhbdhbdhbdhbdhbhbdhbdhbdhbdhbdbdbhbdhbhdbhhbdbhdhbdhbhbdhbdhbdhbhdbhbdhbdhbdhbhbd", url: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Earth_from_Space.jpg/1200px-Earth_from_Space.jpg"))
            makeRequest(path: "specifity", method: .get) { (result: Result<[SpecificityModel], Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let specificityList):
                        self.specificityList = specificityList
                        self.pageType = .matchNotFound
                    case .failure(let error):
                        if error.localizedDescription == "The Internet connection appears to be offline." {
                            self.pageType = .internetError
                        }
                        else {
                            self.pageType = .matchNotFound
                        }
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
