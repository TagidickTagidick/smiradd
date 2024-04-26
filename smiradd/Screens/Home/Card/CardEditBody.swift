import SwiftUI
import PhotosUI
import Combine

struct CardScreen: View {
    @State private var pageType: PageType = .loading
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var cardSettings: CardSettings
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var avatarUrl: String = ""
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var showAvatarPicker: Bool = false
    @State private var showAvatarCamera: Bool = false
    @State private var avatarUIImage: UIImage?
    
//    func da() {
//        if logoUIImage == nil {
//            if !logoUrl.isEmpty {
//                if cardSettings.serviceIndex == -1 {
//                    cardSettings.services.append(
//                        ServiceModel(
//                        name: name,
//                        description: description,
//                        price: Int(price) ?? 0,
//                        coverUrl: coverUrl
//                    )
//                    )
//                }
//                else {
//                    cardSettings.services.insert(
//                        ServiceModel(
//                        name: name,
//                        description: description,
//                        price: Int(price) ?? 0,
//                        coverUrl: coverUrl
//                    ),
//                                                 at: cardSettings.serviceIndex
//                    )
//                }
//                router.navigateBack()
//            }
//            
//            if logoImage != nil {
//                self.pageType = .loading
//                uploadImageToServer(image: logoImage!) { (result: Result<DetailsModel, Error>) in
//                    DispatchQueue.main.async {
//                        switch result {
//                        case .success(let detailsModel):
//                            self.coverUrl = detailsModel.details
//                            if cardSettings.serviceIndex == -1 {
//                                cardSettings.services.append(
//                                    ServiceModel(
//                                    name: name,
//                                    description: description,
//                                    price: Int(price) ?? 0,
//                                    coverUrl: "https://s3.timeweb.cloud/29ad2e34-vizme/\(coverUrl)"
//                                )
//                                )
//                            }
//                            else {
//                                cardSettings.services.insert(
//                                    ServiceModel(
//                                    name: name,
//                                    description: description,
//                                    price: Int(price) ?? 0,
//                                    coverUrl: "https://s3.timeweb.cloud/29ad2e34-vizme/\(coverUrl)"
//                                ),
//                                                             at: cardSettings.serviceIndex
//                                )
//                            }
//                            self.pageType = .nothingHere
//                            router.navigateBack()
//                        case .failure(let error):
//                            if error.localizedDescription == "The Internet connection appears to be offline." {
//                                self.pageType = .internetError
//                            }
//                            else {
//                                self.pageType = .nothingHere
//                            }
//                            print(error.localizedDescription)
//                        }
//                    }
//                }
//            }
//        }
//        else {
//            self.pageType = .loading
//            uploadUIImageToServer(image: logoUIImage!) { (result: Result<DetailsModel, Error>) in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let detailsModel):
//                        self.coverUrl = detailsModel.details
//                        if cardSettings.serviceIndex == -1 {
//                            cardSettings.services.append(
//                                ServiceModel(
//                                name: name,
//                                description: description,
//                                price: Int(price) ?? 0,
//                                coverUrl: "https://s3.timeweb.cloud/29ad2e34-vizme/\(coverUrl)"
//                            )
//                            )
//                        }
//                        else {
//                            cardSettings.services.insert(
//                                ServiceModel(
//                                name: name,
//                                description: description,
//                                price: Int(price) ?? 0,
//                                coverUrl: "https://s3.timeweb.cloud/29ad2e34-vizme/\(coverUrl)"
//                            ),
//                                                         at: cardSettings.serviceIndex
//                            )
//                        }
//                        self.pageType = .nothingHere
//                        router.navigateBack()
//                    case .failure(let error):
//                        if error.localizedDescription == "The Internet connection appears to be offline." {
//                            self.pageType = .internetError
//                        }
//                        else {
//                            self.pageType = .nothingHere
//                        }
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//        }
//    }
    
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
                                    if cardSettings.isEdit {
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
                                }
                                .padding([.vertical, .horizontal], 20)
                            }
                            .frame(height: 360)
                            CardEditBody()
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
