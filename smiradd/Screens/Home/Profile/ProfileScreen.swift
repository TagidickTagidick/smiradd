import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var router: Router
    
    @State private var pageType: PageType = .loading
    
    @EnvironmentObject var profileSettings: ProfileSettings
    @EnvironmentObject var cardSettings: CardSettings
    
    @State private var cards: [CardModel] = []
    
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
                                if profileSettings.notificationsModel != nil && !profileSettings.notificationsModel!.items.filter({ $0.status != "READED" }).isEmpty {
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
                                    Text(String(profileSettings.notificationsModel!.items.filter { $0.status != "READED" }.count))
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
                                router.navigate(to: .notificationsScreen)
                            }
                        Spacer()
                            .frame(width: 24)
                        Image("settings")
                            .onTapGesture {
                                router.navigate(to: .settingsScreen)
                            }
                    }
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        if profileSettings.profileModel?.picture_url == nil {
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
                                    string: profileSettings.profileModel!.picture_url!
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
                            Text("\(profileSettings.profileModel?.first_name ?? "") \(profileSettings.profileModel?.last_name ?? "")")
                                .font(
                                    .custom(
                                        "OpenSans-SemiBold",
                                        size: 22
                                    )
                                )
                                .foregroundStyle(textDefault)
                            Spacer()
                                .frame(height: 12)
                            Text(profileSettings.profileModel?.email ?? "")
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
                    HStack {
                        Text("Мои визитки")
                            .font(
                                .custom(
                                    "OpenSans-SemiBold",
                                    size: 24
                                )
                            )
                            .foregroundStyle(textDefault)
                        Spacer()
                        Image(systemName: "plus")
                            .frame(
                                width: 36,
                                height: 36
                            )
                            .foregroundStyle(textDefault)
                            .onTapGesture {
                                cardSettings.cardType = .newCard
                                cardSettings.services = []
                                cardSettings.achievements = []
                                router.navigate(to: .cardScreen)
                            }
                    }
                    Spacer()
                        .frame(height: 20)
                    if pageType == .matchNotFound {
                        ForEach(cards) { cardModel in
                            MyCard(cardModel: cardModel)
                                .onTapGesture {
                                    cardSettings.cardType = .editCard
                                    cardSettings.cardId = cardModel.id
                                    cardSettings.services = []
                                    cardSettings.achievements = []
                                    router.navigate(to: .cardScreen)
                                }
                        }
                    }
                    else {
                        CustomWidget(
                            pageType: $pageType,
                            onTap: {
                                cardSettings.cardType = .newCard
                                cardSettings.services = []
                                cardSettings.achievements = []
                                router.navigate(to: .cardScreen)
                            }
                        )
                    }
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
            makeRequest(path: "profile", method: .get) { (result: Result<ProfileModel, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let profile):
                        self.profileSettings.profileModel = profile
                        makeRequest(path: "cards", method: .get) { (result: Result<[CardModel], Error>) in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let cards):
                                    self.cards = cards
                                    if self.cards.isEmpty {
                                        self.pageType = .nothingHereProfile
                                    }
                                    else {
                                        self.pageType = .matchNotFound
                                    }
                                    makeRequest(
                                        path: "notifications",
                                        method: .get
                                    ) { (result: Result<NotificationsModel, Error>) in
                                        DispatchQueue.main.async {
                                            switch result {
                                            case .success(let notificationsModel):
                                                self.profileSettings.notificationsModel = notificationsModel
                                                self.pageType = .matchNotFound
                                            case .failure(let error):
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                case .failure(let error):
                                    if error.localizedDescription == "The Internet connection appears to be offline." {
                                        self.pageType = .noResultsFound
                                    }
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    case .failure(let error):
                        if error.localizedDescription == "The Internet connection appears to be offline." {
                            self.pageType = .noResultsFound
                        }
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
