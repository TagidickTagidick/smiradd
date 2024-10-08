import SwiftUI
import CodeScanner
import Shimmer

struct FavoritesPageView: View {
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
            if self.viewModel.pageType == .matchNotFound || self.viewModel.pageType == .loading {
                ScrollView {
                    VStack {
                        if self.viewModel.pageType == .loading {
                            FavoritesLoadingView()
                        }
                        else {
                            FavoritesBodyView(
                                favorites: self.viewModel.favoritesModel!.items,
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
                        pageType: self.viewModel.pageType,
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
        }
        .background(accent50)
    }
}
