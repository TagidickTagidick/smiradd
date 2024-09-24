import SwiftUI
import Shimmer

struct MyCardsView: View {
    let createCard: (() -> ())
    let openExistingCard: ((String) -> ())
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @StateObject private var carouselVM = CarouselViewModel()
    
    var body: some View {
        VStack {
            ProfileTileView(
                text: "Мои визитки",
                onTap: {
                    self.createCard()
                },
                showButton: true
            )
            Spacer()
                .frame(height: 20)
            if self.commonViewModel.cards.isEmpty {
                ProfileNoCardsView(
                    title: "Здесь пока пусто",
                    description: "Создайте визитку, чтобы начать делиться ей с другими людьми",
                    onTap: {
                        self.createCard()
                    }
                )
            }
            else {
                MyCardsCarouselView(
                    cards: self.commonViewModel.cards,
                    onTapCard: {
                        id in
                        self.openExistingCard(id)
                    }
                )
                    .environmentObject(self.carouselVM.stateModel)
            }
        }
    }
}
