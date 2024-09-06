import SwiftUI
import CodeScanner

struct FavoritesScreen: View {
    @EnvironmentObject private var router: NavigationService
    
    @EnvironmentObject private var cardSettings: CardViewModel
    
    @EnvironmentObject private var favoritesSettings: FavoritesSettings
    
    @State private var pageType: PageType = .loading
    
    @State private var isShowingScanner: Bool = false
    
    func handleScan(result: Result<ScanResult, ScanError>) {
       isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            UIApplication
                    .shared
                    .open(URL(string: details[0])!)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        ZStack {
            if pageType == .matchNotFound && favoritesSettings.favoritesModel != nil {
                ScrollView {
                    VStack {
                        HStack (alignment: .center) {
                            Text("Избранное")
                                .font(
                                    .custom(
                                        "OpenSans-SemiBold",
                                        size: 24
                                    )
                                )
                                .foregroundStyle(textDefault)
                            Spacer()
                            Image("filter")
                                .onTapGesture {
                                    router.navigate(to: .filterScreen)
                                }
                            Spacer()
                                .frame(width: 24)
                            Image("scan")
                                .sheet(isPresented: $isShowingScanner) {
                                    CodeScannerView(
                                        codeTypes: [.qr],
                                        simulatedData: "Paul Hudson\npaul@hackingwithswift.com",
                                        completion: handleScan
                                    )
                                }
                                .onTapGesture {
                                    isShowingScanner = true
                                }
                        }
                        Spacer()
                            .frame(height: 20)
//                        ForEach(favoritesSettings.favoritesModel!.items) { cardModel in
//                            if favoritesSettings.mySpecificities.contains(cardModel.specificity) || favoritesSettings.mySpecificities.isEmpty {
//                                MyCard(cardModel: cardModel)
//                                    .onTapGesture {
//                                        cardSettings.cardType = .favoriteCard
//                                        cardSettings.cardId = cardModel.id
//                                        router.navigate(to: .cardScreen)
//                                    }
//                            }
//                        }
                        Spacer()
                            .frame(height: 78)
                    }
                    .padding(
                        [.horizontal],
                        20
                    )
                }
            }
            else {
                VStack {
                    HStack (alignment: .center) {
                        Text("Избранное")
                            .font(
                                .custom(
                                    "OpenSans-SemiBold",
                                    size: 24
                                )
                            )
                            .foregroundStyle(textDefault)
                        Spacer()
                        Image("filter")
                            .onTapGesture {
                                router.navigate(to: .filterScreen)
                            }
                        Spacer()
                            .frame(width: 24)
                        Image("scan")
                            .sheet(isPresented: $isShowingScanner) {
                                CodeScannerView(
                                    codeTypes: [.qr],
                                    simulatedData: "Paul Hudson\npaul@hackingwithswift.com",
                                    completion: handleScan
                                )
                            }
                            .onTapGesture {
                                isShowingScanner = true
                            }
                    }
                    Spacer()
                        .frame(height: 20)
                    CustomWidget(
                        pageType: $pageType,
                        onTap: {
                            cardSettings.services = []
                            cardSettings.achievements = []
                            router.navigate(to: .cardScreen(cardId: "", cardType: .newCard))
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
            makeRequest(
                path: "my/favorites",
                method: .get
            ) { (result: Result<FavoritesModel, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let favoritesModel):
                        self.favoritesSettings.favoritesModel = favoritesModel
                        if self.favoritesSettings.favoritesModel!.items.isEmpty {
                            self.pageType = .nothingHereFavorites
                        }
                        else {
                            self.pageType = .matchNotFound
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
