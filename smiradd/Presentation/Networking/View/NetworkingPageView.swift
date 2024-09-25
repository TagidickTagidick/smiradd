import SwiftUI
import CardStack

struct NetworkingPageView: View {
    @StateObject private var viewModel: NetworkingViewModel
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @FocusState private var emailIsFocused: Bool
    @FocusState private var passwordIsFocused: Bool
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    private let screenHeight = UIScreen.main.bounds.height
    
    init(
        repository: INetworkingRepository,
        navigationService: NavigationService,
        locationManager: LocationManager,
        commonViewModel: CommonViewModel,
        commonRepository: CommonRepository
    ) {
        _viewModel = StateObject(
            wrappedValue: NetworkingViewModel(
                repository: repository,
                navigationService: navigationService,
                locationManager: locationManager,
                commonViewModel: commonViewModel,
                commonRepository: commonRepository
            )
        )
    }
    
    var body: some View {
        ZStack (alignment: .top) {
            CustomWidget(
                pageType: $viewModel.pageType,
                onTap: {
                    if self.viewModel.pageType == .matchNotFound || self.viewModel.pageType == .pageNotFound {
                        if self.viewModel.pageType == .matchNotFound {
                            self.viewModel.openForumCodeSheet()
                        }
                        else {
                            self.viewModel.startAgain()
                        }
                    }
                }
            )
            .padding([.horizontal], 20)
            .padding([.top], 16)
            .padding([.bottom], 52)
            .onChange(
                of: self.viewModel.pinCode,
                {
                    self.viewModel.setForumCode()
                }
            )
//            .frame(
//                width: UIScreen.main.bounds.size.width - 40,
//                height: UIScreen.main.bounds.size.height - 153 - safeAreaInsets.top - safeAreaInsets.bottom
//            )
            .offset(y: 52)
            if self.commonViewModel.isTeamStorage {
                CardSwiperView(
                    cards: $commonViewModel.teamViews,
                    onCardSwiped: {
                        swipeDirection, index in
                                switch swipeDirection {
                                case .left:
                                    self.viewModel.setSeen(
                                        id: self.commonViewModel.teamViews[index].teamModel.id!
                                    )
                                case .right:
                                    self.viewModel.setSeen(
                                        id: commonViewModel.teamViews[index].teamModel.id!
                                    )
                                }
                            },
                    onCardDragged: {
                        swipeDirection, index, offset in
                                print("Card dragged \(swipeDirection) direction at index \(index) with offset \(offset)")
                            }
                )
                .offset(y: 52)
//                .frame(
//                    width: UIScreen.main.bounds.size.width,
//                    height: UIScreen.main.bounds.size.height - 58 - self.safeAreaInsets.bottom - self.safeAreaInsets.top
//                )
            }
            else {
                CardSwiperView(
                    cards: $commonViewModel.cardViews,
                    onCardSwiped: {
                        swipeDirection, index in
                                switch swipeDirection {
                                case .left:
                                    self.viewModel.setSeen(
                                        id: self.commonViewModel.cardViews[index].cardModel.id
                                    )
                                case .right:
                                    self.viewModel.setSeen(
                                        id: self.commonViewModel.cardViews[index].cardModel.id
                                    )
                                }
                            },
                    onCardDragged: {
                        swipeDirection, index, offset in
                                print("Card dragged \(swipeDirection) direction at index \(index) with offset \(offset)")
                            }
                )
                .offset(y: 52)
////                .frame(
////                    width: UIScreen.main.bounds.size.width,
////                    height: UIScreen.main.bounds.size.height - 58 - self.safeAreaInsets.bottom - self.safeAreaInsets.top
////                )
            }
            NetworkingAppBarView(
                onTapExit: {
                    self.viewModel.openExitNetworkingSheet()
                },
                onTapFilter: {
                    self.viewModel.openFilterSheet()
                }
            )
            .background(accent50)
            .sheet(
                isPresented: $viewModel.isFilterSheet,
                onDismiss: {
                    self.viewModel.closeFilterSheet()
                }) {
                    FilterSheetView(
                        isFilter: $viewModel.isFilterSheet
                    )
                    .environmentObject(self.viewModel)
                }
        }
//        .frame(
//            width: UIScreen.main.bounds.size.width - 40,
//            height: UIScreen.main.bounds.size.height - 153 - safeAreaInsets.top - safeAreaInsets.bottom
//        )
//        ZStack (
//            alignment: .top
//        ) {
//            VStack {
//                NetworkingAppBarView(
//                    onTapExit: {
//                        self.viewModel.openExitNetworkingSheet()
//                    },
//                    onTapFilter: {
//                        self.viewModel.openFilterSheet()
//                    }
//                )
//                .sheet(
//                    isPresented: $viewModel.isFilterSheet,
//                    onDismiss: {
//                        self.viewModel.closeFilterSheet()
//                    }) {
//                        FilterSheetView(
//                            isFilter: $viewModel.isFilterSheet
//                        )
//                        .environmentObject(self.viewModel)
//                    }
//                Spacer()
//                    .frame(
//                        height: 16
//                    )
//                ZStack {
//                    CustomWidget(
//                        pageType: $viewModel.pageType,
//                        onTap: {
//                            if self.viewModel.pageType == .matchNotFound || self.viewModel.pageType == .pageNotFound {
//                                if self.viewModel.pageType == .matchNotFound {
//                                    self.viewModel.openForumCodeSheet()
//                                }
//                                else {
//                                    self.viewModel.startAgain()
//                                }
//                            }
//                        }
//                    )
//                    .onChange(
//                        of: self.viewModel.pinCode,
//                        {
//                            self.viewModel.setForumCode()
//                    }
//                    )
//                    .frame(
//                        width: UIScreen.main.bounds.size.width - 40,
//                        height: UIScreen.main.bounds.size.height - 153 - safeAreaInsets.top - safeAreaInsets.bottom
//                    )
//                    if self.commonViewModel.isTeamStorage {
//                        CardSwiperView(
//                            cards: $commonViewModel.teamViews,
//                            onCardSwiped: {
//                                swipeDirection, index in
//                                        switch swipeDirection {
//                                        case .left:
//                                            self.viewModel.setSeen(
//                                                id: self.commonViewModel.teamViews[index].teamModel.id!
//                                            )
//                                        case .right:
//                                            self.viewModel.setSeen(
//                                                id: commonViewModel.teamViews[index].teamModel.id!
//                                            )
//                                        }
//                                    },
//                            onCardDragged: {
//                                swipeDirection, index, offset in
//                                        print("Card dragged \(swipeDirection) direction at index \(index) with offset \(offset)")
//                                    }
//                        )
//        //                .frame(
//        //                    width: UIScreen.main.bounds.size.width,
//        //                    height: UIScreen.main.bounds.size.height - 58 - self.safeAreaInsets.bottom - self.safeAreaInsets.top
//        //                )
//                    }
//                    else {
//                        CardSwiperView(
//                            cards: $commonViewModel.cardViews,
//                            onCardSwiped: {
//                                swipeDirection, index in
//                                        switch swipeDirection {
//                                        case .left:
//                                            self.viewModel.setSeen(
//                                                id: self.commonViewModel.cardViews[index].cardModel.id
//                                            )
//                                        case .right:
//                                            self.viewModel.setSeen(
//                                                id: self.commonViewModel.cardViews[index].cardModel.id
//                                            )
//                                        }
//                                    },
//                            onCardDragged: {
//                                swipeDirection, index, offset in
//                                        print("Card dragged \(swipeDirection) direction at index \(index) with offset \(offset)")
//                                    }
//                        )
//        //                .frame(
//        //                    width: UIScreen.main.bounds.size.width,
//        //                    height: UIScreen.main.bounds.size.height - 58 - self.safeAreaInsets.bottom - self.safeAreaInsets.top
//        //                )
//                    }
//                }
//            }
//            .frame(
//                width: UIScreen.main.bounds.size.width - 40,
//                height: UIScreen.main.bounds.size.height - 153 - safeAreaInsets.top - safeAreaInsets.bottom
//            )
//        }
        //.ignoresSafeArea()
        .frame(
            width: UIScreen.main.bounds.size.width,
            height: UIScreen.main.bounds.size.height - self.safeAreaInsets.bottom - self.safeAreaInsets.top
        )
        .background(accent50)
        .customAlert(
                        "Покинуть нетворкинг?",
                        isPresented: $viewModel.isExitNetworkingSheet,
                        actionText: "Покинуть"
                    ) {
                        print("ииыи")
                        self.viewModel.closeExitNetworkingSheet()
                    } message: {
                        Text("Вы действительно хотите выйти из нетворкинга?")
                            .font(
                                .custom(
                                    "OpenSans-Regular",
                                    size: 14
                                )
                            )
                            .foregroundStyle(textDefault)
                    }
                    .customAlert(
                                    "У вас уже есть команда",
                                    isPresented: $viewModel.isExitTeam,
                                    actionText: "Покинуть"
                                ) {
                                    self.viewModel.leaveAndLike()
                                } message: {
                                    Text("Чтобы подавать заявку в эту команду вы должны покинуть текущую")
                                        .font(
                                            .custom(
                                                "OpenSans-Regular",
                                                size: 14
                                            )
                                        )
                                        .foregroundStyle(textDefault)
                                }
                                .customAlert(
                                                "Вы уже - лидер команды",
                                                isPresented: $viewModel.isDeleteTeam,
                                                actionText: "Удалить"
                                            ) {
                                                self.viewModel.deleteAndLike()
                                            } message: {
                                                Text("Чтобы подавать заявку в эту команду вы должны удалить свою")
                                                    .font(
                                                        .custom(
                                                            "OpenSans-Regular",
                                                            size: 14
                                                        )
                                                    )
                                                    .foregroundStyle(textDefault)
                                            }
        .networkingAlert(
            "Удалить визитку?",
            isPresented: $viewModel.isForumCodeSheet,
            actionText: "Удалить",
            image: "no_event",
            title: "Введите код форума",
            description: "Начните знакомство с остальными участниками прямо сейчас!",
            action: {
                self.viewModel.isForumCodeSheet = false
            },
            message: {
                PinEntryView(
                    pinLimit: 4,
                    pinCode: $viewModel.pinCode
                )
            }
        )
        .networkingAlert(
            "Удалить визитку?",
            isPresented: $viewModel.noCardsSheet,
            actionText: "Удалить",
            image: "no_cards",
            title: "У вас ещё нет визитки",
            description: "Чтобы начать сохранять чужие визитки, вам нужно создать собственную",
            action: {
                self.viewModel.noCardsSheet = false
            },
            message: {
                CustomButtonView(
                    text: "Создать визитку",
                    color: textDefault,
                    width: UIScreen.main.bounds.width - 80
                )
                .onTapGesture {
                    self.viewModel.createCard()
                }
            }
        )
        .networkingAlert(
            "Удалить визитку?",
            isPresented: $viewModel.isQuestionForumSheet,
            actionText: "Удалить",
            image: "no_event",
            title: "Вы сейчас на '\(self.commonViewModel.forumName)'?",
            description: "Начните знакомство с остальными участниками прямо сейчас!",
            action: {
                self.viewModel.answerNoQuestionForumSheet()
            },
            message: {
                HStack (alignment: .center) {
                    ZStack {
                        Text("Нет")
                            .font(
                                .custom(
                                    "OpenSans-SemiBold",
                                    size: 16
                                )
                            )
                            .foregroundStyle(textDefault)
                    }
                    .frame(
                        width: 120,
                        height: 40
                    )
                    .background(
                        Color(
                            red: 0.949,
                            green: 0.949,
                            blue: 0.949
                        )
                    )
                    .cornerRadius(20)
                    .onTapGesture {
                        self.viewModel.answerNoQuestionForumSheet()
                    }
                    Spacer()
                        .frame(
                            width: 16
                        )
                    ZStack {
                        Text("Да")
                            .font(
                                .custom(
                                    "OpenSans-SemiBold",
                                    size: 16
                                )
                            )
                            .foregroundStyle(.white)
                    }
                    .frame(
                        width: 120,
                        height: 40
                    )
                    .background(textDefault)
                    .cornerRadius(20)
                    .onTapGesture {
                        self.viewModel.answerYesQuestionForumSheet()
                    }
                }
            }
        )
        .networkingAlert(
            "Удалить визитку?",
            isPresented: $viewModel.isChooseStatusSheet,
            actionText: "Удалить",
            image: "no_results_found",
            title: "Выберите статус",
            description: "Чтобы продолжить, выберите статус",
            action: {
                self.viewModel.noCardsSheet = false
            },
            message: {
                VStack {
                    CustomButtonView(
                        text: "Ищу команду",
                        color: textDefault,
                        width: UIScreen.main.bounds.width - 80
                    )
                    .frame(
                        width: UIScreen.main.bounds.size.width - 160
                    )
                    .onTapGesture {
                        self.viewModel.setIsSteam(isTeam: true)
                    }
                    CustomButtonView(
                        text: "Ищу участников",
                        color: textAccent,
                        width: UIScreen.main.bounds.width - 80
                    )
                    .frame(
                        width: UIScreen.main.bounds.size.width - 160
                    )
                    .onTapGesture {
                        self.viewModel.setIsSteam(isTeam: false)
                    }
                }
            }
        )
    }
}
