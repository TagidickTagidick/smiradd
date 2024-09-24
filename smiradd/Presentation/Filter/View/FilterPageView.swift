import SwiftUI

struct FilterPageView: View {
    @EnvironmentObject var navigationService: NavigationService
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @FocusState private var findIsFocused: Bool
    
    @StateObject var viewModel: FilterViewModel
    
    init(
        commonRepository: ICommonRepository,
        navigationService: NavigationService,
        commonSpecifities: [String],
        isFavorites: Bool
    ) {
        _viewModel = StateObject(
            wrappedValue: FilterViewModel(
                commonRepository: commonRepository,
                navigationService: navigationService,
                commonSpecifities: commonSpecifities,
                isFavorites: isFavorites
            )
        )
    }
    
    var body: some View {
        ZStack (alignment: .bottom) {
            VStack (alignment: .leading) {
                CustomAppBarView(
                    title: "Фильтр",
                    onClear: {
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
                        ForEach(self.viewModel.currentSpecifities) {
                            specificity in
                            HStack {
                                Text(specificity.name)
                                    .font(
                                        .custom(
                                            self.viewModel.isFavorites ? self.viewModel.favoritesSpecificities.contains(specificity.name)
                                            ? "OpenSans-SemiBold"
                                            : "OpenSans-Regular" :  self.viewModel.networkingSpecificities.contains(specificity.name)
                                            ? "OpenSans-SemiBold"
                                            : "OpenSans-Regular",
                                            size: 16
                                        )
                                    )
                                    .foregroundStyle(textDefault)
                                Spacer()
                                ZStack {
                                    if self.viewModel.favoritesSpecificities.contains(specificity.name) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .frame(
                                                width: 10,
                                                height: 8
                                            )
                                    }
                                }
                                .frame(
                                    width: 20,
                                    height: 20
                                )
                                .background(
                                    self.viewModel.isFavorites ? self.viewModel.favoritesSpecificities.contains(specificity.name)
                                    ? Color(
                                        red: 0.408,
                                        green: 0.784,
                                        blue: 0.58
                                    )
                                    : .white
                                    : self.viewModel.networkingSpecificities.contains(specificity.name)
                                    ? Color(
                                        red: 0.408,
                                        green: 0.784,
                                        blue: 0.58
                                    )
                                    : .white
                                )
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(
                                            accent100,
                                            lineWidth: 1
                                        )
                                )
                            }
                            .padding([.vertical], 12)
                            .background(.white)
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
