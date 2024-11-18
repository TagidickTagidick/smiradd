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
        navigationService: NavigationService,
        locationManager: LocationManager,
        commonViewModel: CommonViewModel,
        commonRepository: CommonRepository
    ) {
        _viewModel = StateObject(
            wrappedValue: NetworkingViewModel(
                navigationService: navigationService,
                locationManager: locationManager,
                commonViewModel: commonViewModel,
                commonRepository: commonRepository
            )
        )
    }
    
    var body: some View {
        ZStack (
            alignment: .top
        ) {
            if self.commonViewModel.networkingPageType != .loading {
                PageInfoView(
                    pageType: self.commonViewModel.networkingPageType,
                    onTap: {
                        if self.commonViewModel.networkingPageType == .matchNotFound || self.commonViewModel.networkingPageType == .pageNotFound {
                            if self.commonViewModel.networkingPageType == .matchNotFound {
                                self.viewModel.openForumCodeSheet()
                            }
                            else {
                                self.commonViewModel.startAgain()
                            }
                        }
                    }
                )
                .offset(
                    y: 70
                )
                .onChange(
                    of: self.viewModel.pinCode,
                    {
                        self.viewModel.setForumCode()
                    }
                )
            }
            if self.commonViewModel.isSeekTeamStorage {
                CardStack(
                    model: self.commonViewModel.networkingTeams,
                  onSwipe: { card, direction in
                      self.commonViewModel.dislike(id: card.id!)
                  },
                  content: { card, _ in
                    NetworkingTeamView(
                        teamModel: card,
                        onDislike: {
                            withAnimation {
                                self.commonViewModel.networkingTeams.swipe(
                                    direction: .left,
                                    completion: nil
                                )
                            }
                            
                            self.commonViewModel.dislike(id: card.id!)
                        },
                        onLike: {
                            self.commonViewModel.like(id: card.id!)
                        },
                        onOpen: {
                            self.viewModel.openTeam(id: card.id!)
                        }
                    )
                  }
                )
                .offset(
                    x: 20,
                    y: 70// + self.safeAreaInsets.top
                )
            }
            else {
                CardStack(
                    model: self.commonViewModel.networkingCards,
                  onSwipe: { card, direction in
                      self.commonViewModel.dislike(id: card.id)
                  },
                  content: { card, _ in
                    NetworkingCardView(
                        cardModel: card,
                        onDislike: {
                            withAnimation {
                                self.commonViewModel.networkingTeams.swipe(
                                    direction: .left,
                                    completion: nil
                                )
                            }
                            
                            self.commonViewModel.dislike(id: card.id)
                        },
                        onLike: {
                            self.commonViewModel.like(id: card.id)
                        },
                        onOpen: {
                            self.viewModel.openCard(id: card.id)
                        }
                    )
                  }
                )
                .offset(
                    x: 20,
                    y: 70// + self.safeAreaInsets.top
                )
            }
            NetworkingAppBarView(
                onTapExit: {
                    if (self.commonViewModel.forumCode ?? "").isEmpty {
                        self.viewModel.openForumCodeSheet()
                    }
                    else {
                        self.viewModel.openExitNetworkingSheet()
                    }
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
                    .environment(\.sizeCategory, .medium)
                }
        }
        .background(accent50)
        .customAlert(
                        "Покинуть нетворкинг?",
                        isPresented: $viewModel.isExitNetworkingSheet,
                        actionText: "Покинуть"
                    ) {
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
                                    isPresented: self.$commonViewModel.isExitTeam,
                                    actionText: "Покинуть"
                                ) {
                                    self.commonViewModel.leaveAndLike()
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
                                                isPresented: self.$commonViewModel.isDeleteTeam,
                                                actionText: "Удалить"
                                            ) {
                                                self.commonViewModel.deleteAndLike()
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
                    pinCode: $viewModel.pinCode
                )
                .onChange(of: self.viewModel.pinCode) {
                    if self.viewModel.pinCode.count == 4 {
                        self.viewModel.setForumCode()
                    }
                }
            }
        )
        .networkingAlert(
            "Удалить визитку?",
            isPresented: self.$commonViewModel.noCardsSheet,
            actionText: "Удалить",
            image: "no_cards",
            title: "У вас ещё нет визитки",
            description: "Чтобы начать сохранять чужие визитки, вам нужно создать собственную",
            action: {
                self.commonViewModel.noCardsSheet = false
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
            title: "Вы сейчас на '\(self.commonViewModel.locationModel?.name ?? "")'?",
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
                self.commonViewModel.noCardsSheet = false
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
                        self.viewModel.setIsTeam(isTeam: true)
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
                        self.viewModel.setIsTeam(isTeam: false)
                    }
                }
            }
        )
    }
}
