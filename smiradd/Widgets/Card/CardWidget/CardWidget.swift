import SwiftUI
import CardStack

struct CardWidget: View {
    var cardModel: CardModel
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var cardSettings: CardSettings
    @EnvironmentObject var profileSettings: ProfileSettings
    
    @Binding var cards: CardStackModel<CardModel, LeftRight>
    
    var body: some View {
        ZStack {
            VStack {
                if cardModel.avatar_url == nil {
                    Image("avatar")
                }
                else {
                    AsyncImage(
                        url: URL(
                            string: cardModel.avatar_url!
                        )
                    ) { image in
                        image
                            .resizable()
                            .frame(height: 337)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 337)
                }
                VStack {
                    CardLogo(cardModel: cardModel)
                    if cardModel.bio != nil {
                        CardBio(bio: cardModel.bio!)
                    }
                    Spacer()
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        Text("100 м отсюда")
                            .font(
                                .custom(
                                    "OpenSans-Regular",
                                    size: 15
                                )
                            )
                            .foregroundStyle(textDefault)
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color(
                                    red: 0.973,
                                    green: 0.404,
                                    blue: 0.4
                                ))
                                .frame(
                                    width: 48,
                                    height: 48
                                )
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            makeRequest(
                                path: "cards/\(cardModel.id)/favorites",
                                method: .delete
                            ) { (result: Result<DetailsModel, Error>) in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success(_):
                                        withAnimation {
                                            cards.swipe(direction: .left, completion: nil)
                                        }
                                    case .failure(_):
                                        print("failure")
                                    }
                                }
                            }
                        }
                        ZStack {
                            Circle()
                                .fill(Color(
                                    red: 0.408,
                                    green: 0.784,
                                    blue: 0.58
                                ))
                                .frame(
                                    width: 48,
                                    height: 48
                                )
                            Image(systemName: "heart")
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            makeRequest(
                                path: "cards/\(cardModel.id)/favorites",
                                method: .post
                            ) { (result: Result<DetailsModel, Error>) in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success(_):
                                        withAnimation {
                                            cards.swipe(direction: .right, completion: nil)
                                        }
                                    case .failure(_):
                                        print("failure")
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(
                    [.horizontal, .vertical],
                    16
                )
            }
        }
        .frame(
            maxWidth: UIScreen.main.bounds.width - 40,
            maxHeight: .infinity
        )
        .background(.white)
        .cornerRadius(16)
        .shadow(
            color: Color(
                red: 0.125,
                green: 0.173,
                blue: 0.275,
                opacity: 0.08
            ),
            radius: 16,
            y: 4
        )
        .onTapGesture {
            cardSettings.cardId = cardModel.id
            let myCard = profileSettings.cards.first(where: { $0.id == cardModel.id }) ?? nil
            if myCard == nil {
                cardSettings.cardType = .userCard
            }
            else {
                cardSettings.cardType = .myCard
            }
            cardSettings.achievements = []
            cardSettings.services = []
            router.navigate(to: .cardScreen)
        }
    }
}
