import SwiftUI

struct MyCardsCarouselView: View {
    @EnvironmentObject var navigationService: NavigationService
    
    let cards: [CardModel]
    let onTapCard: ((String) -> ())
    
    var body: some View {
        let spacing: CGFloat = 8
        let widthOfHiddenCards: CGFloat = 8
        let cardHeight: CGFloat = 228
        
        let items = self.cards
        
        return Canvas {
            Carousel(
                numberOfItems: CGFloat(items.count),
                spacing: spacing,
                widthOfHiddenCards: widthOfHiddenCards
            ) {
                ForEach(
                    Array(self.cards.enumerated()),
                    id: \.offset
                ) {
                    index, element in
                    Item(
                        _id: index,
                        spacing: spacing,
                        widthOfHiddenCards: widthOfHiddenCards,
                        cardHeight: cardHeight
                    ) {
                        MyCardView(
                            cardModel: element,
                            isMyCard: true
                        )
                            .onTapGesture {
                                self.onTapCard(element.id)
                            }
                    }
                    .cornerRadius(8)
                    .transition(AnyTransition.slide)
                    .animation(.spring)
                }
            }
        }
    }
}
