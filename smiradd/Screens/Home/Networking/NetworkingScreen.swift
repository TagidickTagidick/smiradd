import SwiftUI
import CardStack

struct NetworkingScreen: View {
    @EnvironmentObject var router: Router
    
    @State var cards = CardStackModel<_, LeftRight>(CardModel.mock)
    
    @State private var pageType: PageType = .loading
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading) {
                Text("Нетворкинг")
                    .font(
                        .custom(
                            "OpenSans-SemiBold",
                            size: 24
                        )
                    )
                    .foregroundStyle(textDefault)
                Spacer()
                    .frame(height: 20)
                ZStack {
                    CustomWidget(
                        pageType: $pageType,
                        onTap: {
                            self.pageType = .loading
                            makeRequest(path: "cards", method: .get) { (result: Result<[CardModel], Error>) in
                                switch result {
                                case .success(let cards):
                                    self.cards.appendElements(cards)
                                    self.pageType = .matchNotFound
                                case .failure(let error):
                                    if error.localizedDescription == "The Internet connection appears to be offline." {
                                        self.pageType = .noResultsFound
                                    }
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    )
                    CardStack(
                        model: cards,
                        onSwipe: { card, direction in
                            print("Swiped \(card.name) to \(direction)")
                        },
                        content: { card, _ in
                            CardWidget(
                                cardModel: card,
                                cards: $cards
                            )
                                .onTapGesture {
                                    withAnimation {
                                        cards.swipe(direction: .right, completion: nil)
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
            makeRequest(
                path: "networkingv2/aroundme/10",
                method: .get
            ) { (result: Result<[CardModel], Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let cards):
                        for card in cards {
                            if card.like != true {
                                self.cards.appendElement(card)
                            }
                        }
                        self.pageType = .matchNotFound
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
    }
}
