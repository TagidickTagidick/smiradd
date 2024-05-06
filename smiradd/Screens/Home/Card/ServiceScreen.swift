import SwiftUI
import PhotosUI

struct ServiceScreen: View {
    @EnvironmentObject var router: Router
    
    @EnvironmentObject var cardSettings: CardSettings
    
    @State private var pageType: PageType = .matchNotFound
    
    @State private var coverUrl: String = ""
    @State private var coverItem: PhotosPickerItem?
    @State private var coverImage: Image?
    @State private var showCoverPicker: Bool = false
    @State private var showCoverCamera: Bool = false
    @State private var coverUIImage: UIImage?
    
    @State private var name: String = ""
    @FocusState private var nameIsFocused: Bool
    
    @State private var description: String = ""
    @FocusState private var descriptionIsFocused: Bool
    
    @State private var price: String = ""
    @FocusState private var priceIsFocused: Bool
    
    @State private var isAlert = false
    
    var body: some View {
        if pageType == .loading {
            VStack {
                CustomAppBar(title: "Создание услуги")
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
                    CustomAppBar(title: "Создание услуги")
                    Menu {
                        Button("Сделать снимок", action: {
                            self.showCoverCamera.toggle()
                        })
                        Button("Выбрать из галереи", action: {
                            self.showCoverPicker = true
                        })
                            } label: {
                                ZStack {
                                    if coverUIImage == nil {
                                        if !coverUrl.isEmpty {
                                            AsyncImage(
                                                url: URL(
                                                    string: coverUrl
                                                )
                                            ) { image in
                                                image.resizable()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(
                                                width: UIScreen.main.bounds.width - 40,
                                                height: 200
                                                )
                                        }
                                        
                                        if coverImage != nil {
                                            coverImage?
                                                .resizable()
                                                .frame(
                                                    width: UIScreen.main.bounds.width - 40,
                                                    height: 200
                                                    )
                                        }
                                    }
                                    else {
                                        Image(uiImage: coverUIImage!)
                                            .resizable()
                                            .frame(
                                                width: UIScreen.main.bounds.width - 40,
                                                height: 200
                                                )
                                    }
                                    HStack {
                                        Image("edit")
                                        Spacer()
                                            .frame(width: 10)
                                        Text(coverUIImage == nil || coverImage == nil ? "Загрузить обложку" : "Изменить обложку")
                                            .font(
                                                .custom(
                                                    "OpenSans-SemiBold",
                                                    size: 16
                                                )
                                            )
                                            .foregroundStyle(textDefault)
                                    }
                                    .frame(
                                        minWidth: UIScreen.main.bounds.width - 92,
                                        minHeight: 48
                                    )
                                    .background(.white.opacity(0.6))
                                    .cornerRadius(28)
                                }
                                .frame(
                                    minWidth: UIScreen.main.bounds.width - 40,
                                    minHeight: 200
                                )
                                .background(textDefault).opacity(0.48)
                                .cornerRadius(16)
                            }
                            .fullScreenCover(isPresented: self.$showCoverCamera) {
                                accessCameraView(selectedImage: self.$coverUIImage)
                                    .edgesIgnoringSafeArea(.all)
                            }
                            .photosPicker(isPresented: $showCoverPicker, selection: $coverItem)
                            .onChange(of: coverItem) {
                                Task {
                                    if let loaded = try? await coverItem?.loadTransferable(type: Image.self) {
                                        coverImage = loaded
                                        coverUIImage = nil
                                    } else {
                                        print("Failed")
                                    }
                                }
                            }
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
                    Text("Описание*")
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
                        height: 177,
                        limit: 300,
                        isLongText: true
                    )
                    .onTapGesture {
                        descriptionIsFocused = true
                    }
                    Spacer()
                        .frame(height: 20)
                    Text("Стоимость")
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
                        value: $price,
                        hintText: "Введите сумму в рублях",
                        focused: $priceIsFocused,
                        limit: 7
                    )
                    .keyboardType(.numberPad)
                    .onTapGesture {
                        priceIsFocused = true
                    }
                    .onChange(of: price) {
                        if price.count > 3 && price.count < 8{
                            price = price.replacingOccurrences(of: " ", with: "")
                            let indexToAdd = price.index(
                                before: price.index(
                                    price.endIndex,
                                    offsetBy: -2
                                )
                            )
                            price.insert(contentsOf: " ", at: indexToAdd)
                        }
                    }
                    if cardSettings.serviceIndex != -1 {
                        DeleteWidget(text: "услугу")
                            .onTapGesture {
                                isAlert.toggle()
                            }
                            .customAlert(
                                            "Удалить?",
                                            isPresented: $isAlert,
                                            actionText: "Удалить"
                                        ) {
                                            cardSettings.services.remove(at: cardSettings.serviceIndex)
                                            router.navigateBack()
                                        } message: {
                                            Text("Усдуга и вся информация в ней будут удалены. Удалить услугу?")
                                        }
                    }
                    Spacer()
                        .frame(height: 32)
                    SaveButton(canSave:
                                !name.isEmpty
                               && !description.isEmpty
                               && (
                                !coverUrl.isEmpty
                                   || coverImage != nil
                                   || coverUIImage != nil
                                  )
                    )
                        .onTapGesture {
                            if !name.isEmpty && !description.isEmpty && (
                                !coverUrl.isEmpty
                                   || coverImage != nil
                                   || coverUIImage != nil
                                  ) {
                                if coverUIImage == nil {
                                    if !coverUrl.isEmpty {
                                        if cardSettings.serviceIndex == -1 {
                                            cardSettings.services.append(
                                                ServiceModel(
                                                name: name,
                                                description: description,
                                                price: Int(price) ?? 0,
                                                coverUrl: coverUrl
                                            )
                                            )
                                        }
                                        else {
                                            cardSettings.services.insert(
                                                ServiceModel(
                                                name: name,
                                                description: description,
                                                price: Int(price) ?? 0,
                                                coverUrl: coverUrl
                                            ),
                                                                         at: cardSettings.serviceIndex
                                            )
                                        }
                                        router.navigateBack()
                                    }
                                    
                                    if coverImage != nil {
                                        self.pageType = .loading
                                        uploadImageToServer(image: coverImage!) { (result: Result<DetailsModel, Error>) in
                                            DispatchQueue.main.async {
                                                switch result {
                                                case .success(let detailsModel):
                                                    self.coverUrl = detailsModel.details
                                                    if cardSettings.serviceIndex == -1 {
                                                        cardSettings.services.append(
                                                            ServiceModel(
                                                            name: name,
                                                            description: description,
                                                            price: Int(price) ?? 0,
                                                            coverUrl: "https://s3.timeweb.cloud/29ad2e34-vizme/\(coverUrl)"
                                                        )
                                                        )
                                                    }
                                                    else {
                                                        cardSettings.services.insert(
                                                            ServiceModel(
                                                            name: name,
                                                            description: description,
                                                            price: Int(price) ?? 0,
                                                            coverUrl: "https://s3.timeweb.cloud/29ad2e34-vizme/\(coverUrl)"
                                                        ),
                                                                                     at: cardSettings.serviceIndex
                                                        )
                                                    }
                                                    self.pageType = .matchNotFound
                                                    router.navigateBack()
                                                case .failure(let error):
                                                    if error.localizedDescription == "The Internet connection appears to be offline." {
                                                        self.pageType = .noResultsFound
                                                    }
                                                    else {
                                                        self.pageType = .somethingWentWrong
                                                    }
                                                    print(error.localizedDescription)
                                                }
                                            }
                                        }
                                    }
                                }
                                else {
                                    self.pageType = .loading
                                    uploadUIImageToServer(image: coverUIImage!) { (result: Result<DetailsModel, Error>) in
                                        DispatchQueue.main.async {
                                            switch result {
                                            case .success(let detailsModel):
                                                self.coverUrl = detailsModel.details
                                                if cardSettings.serviceIndex == -1 {
                                                    cardSettings.services.append(
                                                        ServiceModel(
                                                        name: name,
                                                        description: description,
                                                        price: Int(price) ?? 0,
                                                        coverUrl: "https://s3.timeweb.cloud/29ad2e34-vizme/\(coverUrl)"
                                                    )
                                                    )
                                                }
                                                else {
                                                    cardSettings.services.insert(
                                                        ServiceModel(
                                                        name: name,
                                                        description: description,
                                                        price: Int(price) ?? 0,
                                                        coverUrl: "https://s3.timeweb.cloud/29ad2e34-vizme/\(coverUrl)"
                                                    ),
                                                                                 at: cardSettings.serviceIndex
                                                    )
                                                }
                                                self.pageType = .matchNotFound
                                                router.navigateBack()
                                            case .failure(let error):
                                                if error.localizedDescription == "The Internet connection appears to be offline." {
                                                    self.pageType = .noResultsFound
                                                }
                                                else {
                                                    self.pageType = .somethingWentWrong
                                                }
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                }
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
                self.coverUrl = cardSettings.serviceIndex == -1 ? "" : cardSettings.services[cardSettings.serviceIndex].coverUrl
                self.name = cardSettings.serviceIndex == -1 ? "" : cardSettings.services[cardSettings.serviceIndex].name
                self.description = cardSettings.serviceIndex == -1 ? "" : cardSettings.services[cardSettings.serviceIndex].description
                self.price = cardSettings.serviceIndex == -1 ? "" : String(cardSettings.services[cardSettings.serviceIndex].price)
            }
            .onTapGesture {
                nameIsFocused = false
                descriptionIsFocused = false
                priceIsFocused = false
            }
        }
    }
}


