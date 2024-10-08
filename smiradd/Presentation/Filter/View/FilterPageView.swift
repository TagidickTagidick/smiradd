import SwiftUI

struct FilterPageView: View {
    @EnvironmentObject var navigationService: NavigationService
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @FocusState private var findIsFocused: Bool
    
    @StateObject var viewModel: FilterViewModel
    
    init(
        commonRepository: ICommonRepository,
        navigationService: NavigationService,
        commonViewModel: CommonViewModel,
        currentSpecificities: [String],
        isFavorites: Bool
    ) {
        _viewModel = StateObject(
            wrappedValue: FilterViewModel(
                commonRepository: commonRepository,
                navigationService: navigationService,
                commonViewModel: commonViewModel,
                currentSpecificities: currentSpecificities,
                isFavorites: isFavorites
            )
        )
    }
    
    var body: some View {
        ZStack (alignment: .bottom) {
            VStack (alignment: .leading) {
                CustomAppBarView(
                    title: "Фильтр",
                    onClear: self.viewModel.find.isEmpty ? nil : {
                        self.viewModel.onClearFind()
                    }
                )
                Spacer()
                    .frame(height: 12)
                CustomTextFieldView(
                    value: $viewModel.find,
                    hintText: "Найти",
                    focused: $findIsFocused
                )
                .onChange(of: self.viewModel.find) {
                    self.viewModel.onChangeFind()
                }
                ScrollView (showsIndicators: false) {
                    VStack (alignment: .leading) {
                        ForEach(self.viewModel.currentSpecificities) {
                            specificity in
                            FilterTileView(
                                isFavorite: self.viewModel.isFavorites
                                           ? self.viewModel.favoritesSpecificities.contains(specificity.name)
                                : self.viewModel.networkingSpecificities.contains(specificity.name),
                                name: specificity.name
                            )
                            .onTapGesture {
                                self.viewModel.onTapSpecificity(name: specificity.name)
                            }
                        }
                        Spacer()
                            .frame(height: 142)
                    }
                }
            }
            .padding(
                [.horizontal],
                20
            )
            CustomButtonView(
                text: "Применить",
                color: textDefault
            )
            .offset(
                y: self.viewModel.isFavorites ? self.viewModel.favoritesSpecificities == self.commonViewModel.favoritesSpecificities ? 0
                                       : -74 : self.viewModel.networkingSpecificities == self.commonViewModel.networkingSpecificities ? 0
                : -74
            )
                .animation(.spring())
                .transition(.move(edge: .bottom))
                .onTapGesture {
                    self.commonViewModel.changeSpecificities(
                        newSpecificities: self.viewModel.isFavorites ? self.viewModel.favoritesSpecificities : self.viewModel.networkingSpecificities,
                        isFavorite: self.viewModel.isFavorites
                    )
                    self.viewModel.navigateBack()
                }
        }
        .background(.white)
            .onTapGesture {
                findIsFocused = false
            }
    }
}
