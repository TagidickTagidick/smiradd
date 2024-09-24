import SwiftUI

struct CardPageView: View {
    @StateObject private var viewModel: CardViewModel
    
    init(
        repository: ICardRepository,
        commonRepository: ICommonRepository,
        navigationService: NavigationService,
        commonViewModel: CommonViewModel,
        cardId: String,
        cardType: CardType
    ) {
        _viewModel = StateObject(
            wrappedValue: CardViewModel(
                repository: repository,
                commonRepository: commonRepository,
                navigationService: navigationService,
                commonViewModel: commonViewModel,
                cardId: cardId,
                cardType: cardType
            )
        )
    }
    
    var body: some View {
        ZStack {
            if self.viewModel.pageType == .loading {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            else {
                if self.viewModel.cardType == .editCard || self.viewModel.cardType == .newCard {
                    CardEditView()
                }
                else {
                    CardBodyView()
                }
            }
        }
        .background(.white)
        .environmentObject(self.viewModel)
        .ignoresSafeArea()
    }
}
