import SwiftUI
import CardStack

struct NetworkingPageView: View {
    @StateObject private var viewModel: NetworkingViewModel
    
    @FocusState private var emailIsFocused: Bool
    @FocusState private var passwordIsFocused: Bool
    
    private let screenHeight = UIScreen.main.bounds.height
    
    init(
        repository: INetworkingRepository,
        navigationService: NavigationService
    ) {
        _viewModel = StateObject(
            wrappedValue: NetworkingViewModel(
                repository: repository,
                navigationService: navigationService
            )
        )
    }
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading) {
                HStack {
                    Image("exit_networking")
                        .resizable()
                        .frame(
                            width: 36,
                            height: 36
                        )
                        .onTapGesture {
                            self.viewModel.openExitNetworkingSheet()
                        }
                    Spacer()
                    Text("Нетворкинг")
                        .font(
                            .custom(
                                "OpenSans-SemiBold",
                                size: 24
                            )
                        )
                        .foregroundStyle(textDefault)
                    Spacer()
                    Image("filter_networking")
                        .resizable()
                        .frame(
                            width: 36,
                            height: 36
                        )
                }
                Spacer()
                    .frame(height: 20)
                ZStack {
                    CustomWidget(
                        pageType: $viewModel.pageType,
                        onTap: {
                            if self.viewModel.pageType == .matchNotFound {
                                self.viewModel.isSheet = true
                            }
                            else {
                                self.viewModel.pageType = .loading
                                makeRequest(path: "cards", method: .get) { (result: Result<[CardModel], Error>) in
                                    switch result {
                                    case .success(let cards):
                                        self.viewModel.cards.appendElements(cards)
                                        self.viewModel.pageType = .matchNotFound
                                    case .failure(let error):
                                        if error.localizedDescription == "The Internet connection appears to be offline." {
                                            self.viewModel.pageType = .noResultsFound
                                        }
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        }
                    )
                    CardStack(
                        model: self.viewModel.cards,
                        onSwipe: { card, direction in
                            print("Swiped \(card.name) to \(direction)")
                        },
                        content: { card, _ in
                            CardWidget(
                                cardModel: card,
                                cards: $viewModel.cards
                            )
                            .onTapGesture {
                                withAnimation {
                                    self.viewModel.cards.swipe(direction: .right, completion: nil)
                                }
                            }
                        }
                    )
                    //                    CardStack(
                    //                      data: cards,
                    //                      onSwipe: { card, direction in // Closure to be called when a card is swiped.
                    //                        print("Swiped \(card) to \(direction)")
                    //                      },
                    //                      content: { card, direction, isOnTop in // View builder function
                    //                          CardWidget(cardModel: card)
                    //                              .onTapGesture {
                    //                                  cards.append(CardModel(id: "ыррыры", job_title: "ыррыры", specificity: "ыррыры", phone: "ыррыры", email: "ыррыры", address: "ыррыры", name: "ыррыры", useful: "ыррыры", seek: "ыррыры", tg_url: "ыррыры", vk_url: "ыррыры", fb_url: "ыррыры", cv_url: "ыррыры", company_logo: "ыррыры", bio: "ыррыры", bc_template_type: "ыррыры", services: nil, achievements: nil, avatar_url: "ыррыры"))
                    //                              }
                    //                      }
                    //                    )
                }
                Spacer()
                    .frame(height: 78)
            }
            .padding(
                [.horizontal],
                20
            )
        }
        .background(accent50)
        .onAppear {
            self.viewModel.onInit()
//            makeRequest(
//                path: "networkingv2/aroundme/10",
//                method: .get
//            ) { (result: Result<[CardModel], Error>) in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let cards):
//                        for card in cards {
//                            if card.like != true {
//                                self.cards.appendElement(card)
//                            }
//                        }
//                        print("овыоов \(self.cards)")
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
            
            //            makeRequest(path: "cards", method: .get) { (result: Result<[CardModel], Error>) in
            //                DispatchQueue.main.async {
            //                    switch result {
            //                    case .success(let cards):
            //                        self.cards.appendElements(cards)
            //                        self.pageType = .matchNotFound
            //                    case .failure(let error):
            //                        if error.localizedDescription == "The Internet connection appears to be offline." {
            //                            self.pageType = .internetError
            //                        }
            //                        print(error.localizedDescription)
            //                    }
            //                }
            //            }
        }
        .customAlert(
                        "Покинуть нетворкинг?",
                        isPresented: $viewModel.isExitNetworkingSheet,
                        actionText: "Покинуть"
                    ) {
                        self.viewModel.closeExitNetworkingSheet()
                    } message: {
                        Text("Вы действительно хотите выйти из нетворкинга?")
                            .font(
                                .custom(
                                    "OpenSans-Regular",
                                    size: 14
                                )
                            )
                            .foregroundStyle(textDefault)
                    }
        .forumCode(
            "Удалить визитку?",
            isPresented: $viewModel.isSheet,
            pinCode: $viewModel.pinCode,
            actionText: "Удалить",
            action: {
                self.viewModel.isSheet = false
            },
            message: {
                Text("Визитка и вся информация в ней будут удалены. Удалить визитку?")
            }
        )
    }
}
