import SwiftUI

struct ProfilePageView: View {
    @EnvironmentObject var navigationService: NavigationService
    
    @EnvironmentObject var cardSettings: CardViewModel
    
    @EnvironmentObject var viewModel: ProfileViewModel
    
//    init(
//        repository: IProfileRepository,
//        navigationService: NavigationService
//    ) {
//        _viewModel = StateObject(
//            wrappedValue: ProfileViewModel(
//                repository: repository,
//                navigationService: navigationService
//            )
//        )
//    }
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    HStack (alignment: .center) {
                        Text("Профиль")
                            .font(
                                .custom(
                                    "OpenSans-SemiBold",
                                    size: 24
                                )
                            )
                            .foregroundStyle(textDefault)
                        Spacer()
                            ZStack (alignment: .topLeading) {
                                Image("notifications")
                                if self.viewModel.notificationsModel != nil && !self.viewModel.notificationsModel!.items.filter({ $0.status != "READED" }).isEmpty {
                                    Circle()
                                        .fill(Color(
                                            red: 0.408,
                                            green: 0.784,
                                            blue: 0.58
                                        ))
                                        .frame(
                                            width: 18,
                                            height: 18
                                        )
                                    Text(String(self.viewModel.notificationsModel!.items.filter { $0.status != "READED" }.count))
                                        .font(
                                            .custom(
                                                "OpenSans-Bold",
                                                size: 14
                                            )
                                        )
                                        .foregroundStyle(textDefault)
                                        .offset(x: 5)
                                }
                            }
                            .onTapGesture {
                                navigationService.navigate(to: .notificationsScreen)
                            }
                        Spacer()
                            .frame(width: 24)
                        Image("settings")
                            .onTapGesture {
                                navigationService.navigate(to: .settingsScreen)
                            }
                    }
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        if self.viewModel.profileModel?.picture_url == nil {
                            Image("avatar")
                                .resizable()
                                .frame(
                                    width: 64,
                                    height: 64
                                )
                                .clipShape(Circle())
                        }
                        else {
                            AsyncImage(
                                url: URL(
                                    string: self.viewModel.profileModel!.picture_url!
                                )
                            ) { image in
                                image
                                    .resizable()
                                    .frame(
                                        width: 64,
                                        height: 64
                                    )
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        Spacer()
                            .frame(width: 16)
                        VStack (alignment: .leading) {
                            Text("\(self.viewModel.profileModel?.first_name ?? "") \(self.viewModel.profileModel?.last_name ?? "")")
                                .font(
                                    .custom(
                                        "OpenSans-SemiBold",
                                        size: 22
                                    )
                                )
                                .foregroundStyle(textDefault)
                            Spacer()
                                .frame(height: 12)
                            Text(self.viewModel.profileModel?.email ?? "")
                                .font(
                                    .custom(
                                        "OpenSans-SemiBold",
                                        size: 22
                                    )
                                )
                                .foregroundStyle(textDefault)
                        }
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 28)
                    ProfileTileView(
                        text: "Мои визитки",
                        onTap: {
                            navigationService.navigate(to: .cardScreen(cardId: "", cardType: .newCard))
                        }
                    )
                    Spacer()
                        .frame(height: 20)
                    if self.viewModel.pageType == .matchNotFound {
                        ForEach(self.viewModel.cards) { cardModel in
                            MyCard(cardModel: cardModel)
                                .onTapGesture {
                                    cardSettings.services = []
                                    cardSettings.achievements = []
                                    navigationService.navigate(
                                        to: .cardScreen(cardId: cardModel.id, cardType: .editCard)
                                    )
                                }
                        }
                    }
                    else {
                        ProfileNoCardsView(
                            title: "Здесь пока пусто",
                            description: "Создайте визитку, чтобы начать делиться ей с другими людьми",
                            onTap: {
                                
                            }
                        )
                    }
                    Spacer()
                        .frame(height: 24)
                    ProfileTileView(
                        text: "Моя команда",
                        onTap: {
                            cardSettings.services = []
                            cardSettings.achievements = []
                            navigationService.navigate(to: .cardScreen(cardId: "", cardType: .newCard))
                        }
                    )
                    Spacer()
                        .frame(height: 16)
                    ProfileNoCardsView(
                        title: "У вас пока нет команды",
                        description: "Создайте визитную карту вашей команды или организации",
                        onTap: {
                            
                        }
                    )
                    Spacer()
                        .frame(height: 78)
                }
                .padding(
                    [.horizontal],
                    20
                )
            }
        }
        .background(accent50)
        .onAppear {
            self.viewModel.onAppear()
//            makeRequest(path: "profile", method: .get) { (result: Result<ProfileModel, Error>) in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let profile):
//                        self.viewModel.profileModel = profile
//                        makeRequest(path: "cards", method: .get) { (result: Result<[CardModel], Error>) in
//                            DispatchQueue.main.async {
//                                switch result {
//                                case .success(let cards):
//                                    self.viewModel.cards = cards
//                                    if self.viewModel.cards.isEmpty {
//                                        self.viewModel.pageType = .nothingHereProfile
//                                    }
//                                    else {
//                                        self.viewModel.pageType = .matchNotFound
//                                    }
//                                    makeRequest(
//                                        path: "notifications",
//                                        method: .get
//                                    ) { (result: Result<NotificationsModel, Error>) in
//                                        DispatchQueue.main.async {
//                                            switch result {
//                                            case .success(let notificationsModel):
//                                                self.viewModel.notificationsModel = notificationsModel
//                                                self.viewModel.pageType = .matchNotFound
//                                            case .failure(let error):
//                                                print(error.localizedDescription)
//                                            }
//                                        }
//                                    }
//                                case .failure(let error):
//                                    if error.localizedDescription == "The Internet connection appears to be offline." {
//                                        self.viewModel.pageType = .noResultsFound
//                                    }
//                                    print(error.localizedDescription)
//                                }
//                            }
//                        }
//                    case .failure(let error):
//                        if error.localizedDescription == "The Internet connection appears to be offline." {
//                            self.viewModel.pageType = .noResultsFound
//                        }
//                        print(error.localizedDescription)
//                    }
//                }
//            }
        }
    }
}
