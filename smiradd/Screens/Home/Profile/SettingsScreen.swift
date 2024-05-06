import SwiftUI
import PhotosUI

struct SettingsScreen: View {
    @EnvironmentObject var router: Router
    
    @State private var pageType: PageType = .matchNotFound
    
    @EnvironmentObject var profileSettings: ProfileSettings
    
    @State private var avatarUrl: String = ""
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var showAvatarPicker: Bool = false
    @State private var showAvatarCamera: Bool = false
    @State private var avatarUIImage: UIImage?
    
    @State private var firstName: String = ""
    @FocusState private var firstNameIsFocused: Bool
    
    @State private var lastName: String = ""
    @FocusState private var lastNameIsFocused: Bool
    
    @State private var isHelp: Bool = false
    @State private var isExit: Bool = false
    @State private var isDelete: Bool = false
    
    func saveAvatar() {
        if (!avatarUrl.isEmpty
            || avatarImage != nil
            || avatarUIImage != nil
              ) {
            if avatarUIImage == nil {
                if !avatarUrl.isEmpty {
                    save()
                }
                
                if avatarImage != nil {
                    self.pageType = .loading
                    uploadImageToServer(image: avatarImage!) {
                        (result: Result<DetailsModel, Error>) in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let detailsModel):
                                self.avatarUrl = "https://s3.timeweb.cloud/29ad2e34-vizme/\(detailsModel.details)"
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
                uploadUIImageToServer(image: avatarUIImage!) {
                    (result: Result<DetailsModel, Error>) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let detailsModel):
                            self.avatarUrl = "https://s3.timeweb.cloud/29ad2e34-vizme/\(detailsModel.details)"
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
        let body: [String: String] = [
            "first_name": firstName,
            "last_name": lastName,
            "picture_url": avatarUrl,
        ]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        makeRequest(path: "profile", method: .patch, body: finalBody) { (result: Result<ProfileModel, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileModel):
                    router.navigateBack()
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
    
    var body: some View {
        if pageType == .loading {
            VStack {
                CustomAppBar(title: "Настройки")
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
                    CustomAppBar(title: "Настройки")
                    Spacer()
                        .frame(height: 20)
                    HStack {
                        Spacer()
                        VStack {
                            Menu {
                                Button("Сделать снимок", action: {
                                    self.showAvatarCamera.toggle()
                                })
                                Button("Выбрать из галереи", action: {
                                    self.showAvatarPicker = true
                                })
                                    } label: {
                                        ZStack (alignment: .bottomTrailing) {
                                            if avatarUIImage == nil {
                                                if !avatarUrl.isEmpty {
                                                    AsyncImage(
                                                        url: URL(
                                                            string: avatarUrl
                                                        )
                                                    ) { image in
                                                        image.resizable()
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                    .frame(
                                                        width: 128,
                                                        height: 128
                                                    )
                                                    .clipShape(Circle())
                                                }
                                                else if avatarImage != nil {
                                                    avatarImage?
                                                        .resizable()
                                                        .frame(
                                                            width: 128,
                                                            height: 128
                                                        )
                                                        .clipShape(Circle())
                                                }
                                                else {
                                                    Image("avatar")
                                                        .resizable()
                                                        .frame(
                                                            width: 128,
                                                            height: 128
                                                        )
                                                        .clipShape(Circle())
                                                }
                                            }
                                            else {
                                                Image(uiImage: avatarUIImage!)
                                                    .resizable()
                                                    .frame(
                                                        width: 128,
                                                        height: 128
                                                    )
                                                    .clipShape(Circle())
                                            }
                                            ZStack {
                                                Image("edit")
                                                    .resizable()
                                                    .frame(
                                                        width: 24,
                                                        height: 24
                                                    )
                                            }
                                            .frame(
                                                width: 40,
                                                height: 40
                                            )
                                            .background(.white.opacity(0.6))
                                            .clipShape(Circle())
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
                            Spacer()
                                .frame(height: 16)
                            Text(profileSettings.profileModel?.email ?? "")
                                .font(
                                    .custom(
                                        "OpenSans-Regular",
                                        size: 14
                                    )
                                )
                                .foregroundStyle(textDefault)
                        }
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 16)
                    CustomText(text: "Имя*")
                    Spacer()
                        .frame(height: 8)
                    CustomTextField(
                        value: $firstName,
                        hintText: "Введите имя",
                        focused: $firstNameIsFocused
                    )
                    Spacer()
                        .frame(height: 16)
                    CustomText(text: "Фамилия*")
                    Spacer()
                        .frame(height: 8)
                    CustomTextField(
                        value: $lastName,
                        hintText: "Введите фамилию",
                        focused: $lastNameIsFocused
                    )
                    Spacer()
                        .frame(height: 16)
                    if !firstName.isEmpty || !lastName.isEmpty {
                        if profileSettings.profileModel?.first_name != firstName || profileSettings.profileModel?.last_name != lastName || (
                            !avatarUrl.isEmpty
                               || avatarImage != nil
                               || avatarUIImage != nil
                              ) {
                            Spacer()
                                .frame(height: 24)
                            SaveButton(canSave: true)
                                .onTapGesture {
                                    saveAvatar()
                                }
                        }
                    }
                    SettingsTile(
                        image: "help",
                        text: "Помощь"
                    )
                    .onTapGesture {
                        isHelp = true
                    }
                    .sheet(
                        isPresented: $isHelp,
                           onDismiss: {
                               isHelp = false
                           }) {
                               CirculationCreation(isHelp: $isHelp)
                            }
                    Spacer()
                        .frame(height: 16)
                    SettingsTile(
                        image: "exit",
                        text: "Выйти"
                    )
                    .onTapGesture {
                        isExit.toggle()
                    }
                    .customAlert(
                                    "Выйти из аккаунта?",
                                    isPresented: $isExit,
                                    actionText: "Выйти"
                                ) {
                                    UserDefaults.standard.removeObject(forKey: "access_token")
                                    UserDefaults.standard.removeObject(forKey: "refresh_token")
                                    router.navigateToRoot()
                                    router.navigate(to: .signInScreen)
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
                    SettingsTile(
                        image: "delete_account",
                        text: "Удалить аккаунт"
                    )
                    .onTapGesture {
                        isDelete.toggle()
                    }
                    .customAlert(
                                    "Удалить аккаунт?",
                                    isPresented: $isDelete,
                                    actionText: "Удалить"
                                ) {
                                    makeRequest(
                                        path: "profile",
                                        method: .delete,
                                        isString: true
                                    ) { (result: Result<DeleteModel, Error>) in
                                        DispatchQueue.main.async {
                                            switch result {
                                            case .success(_):
                                                UserDefaults.standard.removeObject(forKey: "access_token")
                                                UserDefaults.standard.removeObject(forKey: "refresh_token")
                                                router.navigate(to: .signInScreen)
                                                self.pageType = .matchNotFound
                                            case .failure(let error):
                                                if error.localizedDescription == "The Internet connection appears to be offline." {
                                                    self.pageType = .internetError
                                                }
                                                else {
                                                    self.pageType = .matchNotFound
                                                }
                                                UserDefaults.standard.removeObject(forKey: "access_token")
                                                UserDefaults.standard.removeObject(forKey: "refresh_token")
                                                router.navigateToRoot()
                                                router.navigate(to: .signInScreen)
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
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
            .onAppear {
                self.firstName = profileSettings.profileModel?.first_name ?? ""
                self.lastName = profileSettings.profileModel?.last_name ?? ""
                self.avatarUrl = profileSettings.profileModel?.picture_url ?? ""
            }
            .onTapGesture {
                firstNameIsFocused = false
                lastNameIsFocused = false
            }
        }
        //.lazyPop()
    }
}
