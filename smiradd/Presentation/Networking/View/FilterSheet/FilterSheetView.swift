import SwiftUI

struct FilterSheetView: View {
    @Binding var isFilter: Bool
    
    @EnvironmentObject private var viewModel: NetworkingViewModel
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @State private var specificitiesHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack (alignment: .leading) {
                Spacer()
                    .frame(height: 32)
                Text("Статус")
                    .font(
                        .custom(
                            "OpenSans-SemiBold",
                            size: 24
                        )
                    )
                    .foregroundStyle(textDefault)
                Spacer()
                    .frame(height: 16)
                HStack {
                    FilterButtonView(
                        isChosen: self.viewModel.isTeam,
                        text: "Ищу команду"
                    )
                    .frame(
                        minWidth: UIScreen.main.bounds.size.width / 2 - 24,
                        minHeight: 40
                    )
                    .background(self.viewModel.isTeam ? textAccent : accent100)
                    .cornerRadius(24)
                    .onTapGesture {
                        self.viewModel.changeTeamSeek(
                            isTeam: true
                        )
                    }
                    Spacer()
                        .frame(
                            width: 8
                        )
                    FilterButtonView(
                        isChosen: !self.viewModel.isTeam,
                        text: "Ищу участников"
                    )
                    .frame(
                        minWidth: UIScreen.main.bounds.size.width / 2 - 24,
                        minHeight: 40
                    )
                    .background(!self.viewModel.isTeam ? textAccent : accent100)
                    .cornerRadius(24)
                    .onTapGesture {
                        self.viewModel.changeTeamSeek(
                            isTeam: false
                        )
                    }
                }
                Spacer()
                    .frame(
                        height: 24
                    )
                HStack {
                    Text("Фильтры")
                        .font(
                            .custom(
                                "OpenSans-SemiBold",
                                size: 24
                            )
                        )
                        .foregroundStyle(textDefault)
                    Spacer()
                    if !self.commonViewModel.networkingSpecificities.isEmpty {
                        Text("Очистить")
                            .font(
                                .custom(
                                    "OpenSans-SemiBold",
                                    size: 16
                                )
                            )
                            .foregroundStyle(
                                Color(
                                red: 0.898,
                                green: 0.271,
                                blue: 0.267
                            )
                            )
                            .onTapGesture {
                                self.commonViewModel.changeSpecificities(
                                    newSpecificities: [],
                                    isFavorite: false
                                )
                            }
                    }
                }
                Spacer()
                    .frame(
                        height: 16
                    )
                if self.commonViewModel.networkingSpecificities.isEmpty {
                    FilterButtonView(
                        isChosen: false,
                        text: "Выбрать"
                    )
                    .onTapGesture {
                        self.viewModel.openFilters()
                    }
                }
                else {
                    GeometryReader {
                        proxy in
                        WrappedLayoutView(
                            onTap: {
                                self.viewModel.openFilters()
                            }
                        )
                        .onChange(of: proxy.size.height) {
                            print(proxy.size.height)
                            self.specificitiesHeight = proxy.size.height
                        }
                    }
                }
                Spacer()
                    .frame(
                        height: 16
                    )
                Spacer()
            }
            .padding(
             [.horizontal],
             20
            )
        }
        .presentationCornerRadius(16)
        .presentationDetents(
            [.height(276 + self.specificitiesHeight)]
        )
    }
}