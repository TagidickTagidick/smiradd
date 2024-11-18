import SwiftUI
import CodeScanner
import Shimmer

struct FavoritesPageView: View {
    @StateObject private var viewModel: FavoritesViewModel
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @Namespace var topID
    
    init(
        repository: IFavoritesRepository,
        navigationService: NavigationService,
        commonRepository: ICommonRepository,
        commonViewModel: CommonViewModel
    ) {
        _viewModel = StateObject(
            wrappedValue: FavoritesViewModel(
                repository: repository,
                navigationService: navigationService,
                commonRepository: commonRepository,
                commonViewModel: commonViewModel
            )
        )
    }
    
    var body: some View {
        ScrollViewReader {
            scrollView in
            ZStack (alignment: .top) {
                if self.commonViewModel.favoritesPageType == .matchNotFound || self.commonViewModel.favoritesPageType == .loading {
                    ScrollView {
                        VStack {
                            if self.commonViewModel.favoritesPageType == .loading {
                                FavoritesLoadingView()
                            }
                            else {
                                FavoritesBodyView(
                                    favorites: self.commonViewModel.favoritesModel!.items,
                                    onDislike: {
                                        id in
                                        self.viewModel.openAlert(
                                            id: id
                                        )
                                    },
                                    onTap: {
                                        id in
                                        self.viewModel.navigateToCard(
                                            id: id
                                        )
                                    },
                                    isAlert: self.$viewModel.isAlert,
                                    onTapAlert: {
                                        self.viewModel.dislike()
                                    }
                                )
                                .id(topID)
                            }
                        }
                        .padding(
                            [.horizontal],
                            20
                        )
                    }
                    .padding(
                        [.top],
                        52
                    )
                    .padding(
                        [.bottom],
                        58
                    )
                    .refreshable {
                        self.viewModel.getFavorites()
                    }
                }
                else {
                    VStack {
                        Spacer()
                        PageInfoView(
                            pageType: self.commonViewModel.favoritesPageType,
                            onTap: {
                                self.viewModel.getFavorites()
                            }
                        )
                        Spacer()
                    }
                }
                FavoritesAppBarView(
                    onTapFilters: {
                        self.viewModel.openFilters()
                    },
                    onTapScan: {
                        self.viewModel.openScanner()
                    },
                    isShowingScanner: self.$viewModel.isShowingScanner,
                    onScan: self.viewModel.handleScan
                )
                .onTapGesture {
                    scrollView.scrollTo(topID)
                }
            }
            .background(accent50)
        }
    }
}
