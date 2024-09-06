import SwiftUI

struct CardPageView: View {
    @StateObject private var viewModel: CardViewModel
    
    init(
        repository: ICardRepository,
        navigationService: NavigationService,
        cardId: String,
        cardType: CardType
    ) {
        _viewModel = StateObject(
            wrappedValue: CardViewModel(
                repository: repository,
                navigationService: navigationService,
                cardId: cardId,
                cardType: cardType
            )
        )
    }
    
    var body: some View {
        ZStack {
            if self.viewModel.pageType == .loading {
                ProgressView()
            }
            else {
                if self.viewModel.cardType == .editCard || self.viewModel.cardType == .newCard {
                    CardEditBody()
                }
                else {
                    CardBody()
                }
            }
        }
        .background(.white)
        .environmentObject(self.viewModel)
    }
}
