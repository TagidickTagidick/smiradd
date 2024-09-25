import SwiftUI
import CodeScanner

struct FavoritesPageView: View {
    @EnvironmentObject private var cardViewModel: CardViewModel
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @StateObject private var viewModel: FavoritesViewModel
    
    init(
        repository: IFavoritesRepository,
        navigationService: NavigationService,
        commonRepository: ICommonRepository
    ) {
        _viewModel = StateObject(
            wrappedValue: FavoritesViewModel(
                repository: repository,
                navigationService: navigationService,
                commonRepository: commonRepository
            )
        )
    }
    
    var body: some View {
        ZStack (alignment: .top) {
            if self.viewModel.pageType == .matchNotFound && self.viewModel.favoritesModel != nil {
                ScrollView {
                    VStack {
                        Spacer()
                            .frame(height: 52)
                        ForEach(
                            Array(
                                self.viewModel.favoritesModel!.items.enumerated()
                            ),
                            id: \.offset
                        ) {
                            index, cardModel in
                            if self.commonViewModel.favoritesSpecificities.contains(cardModel.specificity) || self.commonViewModel.favoritesSpecificities.isEmpty {
                                MyCardView(
                                    cardModel: cardModel,
                                    isMyCard: false,
                                    onDislike: {
                                        id in
                                        self.viewModel.openAlert(id: id)
                                    }
                                )
                                    .onTapGesture {
                                        self.viewModel.navigateToCard(
                                            id: cardModel.id
                                        )
                                    }
                            }
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
            else {
                VStack {
                    Spacer()
                        .frame(height: 52)
                    CustomWidget(
                        pageType: $viewModel.pageType,
                        onTap: {}
                    )
                    Spacer()
                        .frame(height: 78)
                }
                .padding(
                    [.horizontal],
                    20
                )
            }
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
                        self.viewModel.openFilters()
                    }
                Spacer()
                    .frame(width: 24)
                Image("scan")
                    .sheet(isPresented: $viewModel.isShowingScanner) {
                        CodeScannerView(
                            codeTypes: [.qr],
                            simulatedData: "Paul Hudson\npaul@hackingwithswift.com",
                            completion: self.viewModel.handleScan
                        )
                    }
                    .onTapGesture {
                        self.viewModel.openScanner()
                    }
            }
            .padding(
                [.horizontal],
                20
            )
            .padding(
                [.bottom],
                20
            )
            .background(accent50)
        }
        .background(accent50)
        .onAppear {
            self.viewModel.getFavorites()
        }
        .customAlert(
            "Удалить из избранного?",
            isPresented: $viewModel.isAlert,
            actionText: "Удалить"
        ) {
            self.viewModel.dislike()
        } message: {
            Text("Визитка будет удалена, если у вас нет контактов ее владельца, то вернуть ее можно будет только при личной встрече. Удалить визитку из избранного?")
        }
    }
}
