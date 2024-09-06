import SwiftUI
import CardStack

struct CardWidget: View {
    var cardModel: CardModel
    
    @EnvironmentObject var router: NavigationService
    @EnvironmentObject var cardSettings: CardViewModel
    @EnvironmentObject private var viewModel: ProfileViewModel
    
    @Binding var cards: CardStackModel<CardModel, LeftRight>
    
    var body: some View {
        VStack {
            if cardModel.avatar_url == nil {
                Image("avatar")
                    .resizable()
                    .frame(height: (UIScreen.main.bounds.size.height - 150) / 2)
            }
            else {
                AsyncImage(
                    url: URL(
                        string: cardModel.avatar_url!
                    )
                ) { image in
                    image
                        .resizable()
                        .frame(height: (UIScreen.main.bounds.size.height - 150) / 2)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: (UIScreen.main.bounds.size.height - 150) / 2)
            }
            VStack (alignment: .leading) {
                Spacer()
                    .frame(height: 16)
                CardLogo(cardModel: cardModel)
                if cardModel.bio != nil {
                    CardBio(bio: cardModel.bio!)
                }
                Spacer()
                Spacer()
                    .frame(height: 16)
                CardButtons(cardId: cardModel.id)
            }
            .padding(
                [.horizontal, .vertical],
                16
            )
        }
        .frame(
            width: UIScreen.main.bounds.width - 40,
            height: UIScreen.main.bounds.height - 150
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
            let myCard = self.viewModel.cards.first(where: { $0.id == cardModel.id }) ?? nil
            cardSettings.achievements = []
            cardSettings.services = []
            router.navigate(to: .cardScreen(cardId: cardModel.id, cardType: myCard == nil ? .userCard : .myCard))
        }
    }
}
