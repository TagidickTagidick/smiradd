import SwiftUI
import PhotosUI
import Combine

struct TeamBodyView: View {
    @EnvironmentObject var router: NavigationService
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @EnvironmentObject var viewModel: TeamViewModel
    
    @State private var isAlert: Bool = false
    
    @State var imageMock: UIImage? = nil
    @State var videoMock: URL? = nil
    
    @State var teamLogo: String = ""
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    var body: some View {
        ZStack (alignment: .bottomTrailing) {
            ScrollView {
                VStack (alignment: .leading) {
                    CardImageView(
                        image: self.$imageMock,
                        video: self.$videoMock,
                        imageUrl: self.$teamLogo,
                        showTrailing: false,
                        editButton: self.commonViewModel.myCards.contains(
                            where: { $0.id == self.commonViewModel.teamMainModel.owner_card_id}
                        ) ? true : nil,
                        onTapEditButton: {
                            self.viewModel.teamType = .editCard
                        }
                    )
                    .onAppear {
                        self.teamLogo = self.commonViewModel.teamMainModel.team.team_logo ?? ""
                    }
                    VStack (alignment: .leading) {
                        Spacer()
                            .frame(height: 16)
                        Text(self.commonViewModel.teamMainModel.team.name)
                            .font(
                                .custom(
                                    "OpenSans-SemiBold",
                                    size: 24
                                )
                            )
                            .foregroundStyle(textDefault)
                        Spacer()
                            .frame(height: 12)
                        if self.commonViewModel.teamMainModel.team.about_team != nil {
                            if !self.commonViewModel.teamMainModel.team.about_team!.isEmpty {
                                CardBioView(
                                    title: "О команде",
                                    bio: self.commonViewModel.teamMainModel.team.about_team!,
                                    showButton: true
                                )
                                Spacer()
                                    .frame(
                                        height: 16
                                    )
                            }
                        }
                        if self.commonViewModel.teamMainModel.team.about_project != nil {
                            if !self.commonViewModel.teamMainModel.team.about_project!.isEmpty {
                                CardBioView(
                                    title: "О проекте",
                                    bio: self.commonViewModel.teamMainModel.team.about_project!,
                                    showButton: true
                                )
                                Spacer()
                                    .frame(
                                        height: 16
                                    )
                            }
                        }
                        CustomTextView(text: "Лидер")
                        Spacer()
                            .frame(
                                height: 12
                            )
                        MyCardView(
                            cardModel: self.commonViewModel.teamMainModel.teammates.first(
                                where: {
                                    $0.id == self.commonViewModel.teamMainModel.owner_card_id!
                                }
                            )!,
                            isMyCard: false
                        )
                        .onTapGesture {
                            self.viewModel.openCard(
                                id: self.commonViewModel.teamMainModel.owner_card_id!
                            )
                        }
                        Spacer()
                            .frame(
                                height: 16
                            )
                        CustomTextView(text: "Участники")
                        Spacer()
                            .frame(
                                height: 12
                            )
                        ZStack (alignment: .top) {
                            Spacer()
                                .background(textDefault)
                                .frame(
                                    width: UIScreen.main.bounds.size.width - 56,
                                    height: 100
                                )
                                .cornerRadius(16)
                            Spacer()
                                .background(
                                    Color(
                                        red: 0.482,
                                        green: 0.569,
                                        blue: 0.761
                                    )
                                )
                                .frame(
                                    width: UIScreen.main.bounds.size.width - 48,
                                    height: 100
                                )
                                .cornerRadius(16)
                                .offset(y: 8)
                            MyCardView(
                                cardModel: self.commonViewModel.teamMainModel.teammates.first!,
                                isMyCard: false
                            )
                            .onTapGesture {
                                self.viewModel.openCard(
                                    id: self.commonViewModel.teamMainModel.teammates.first!.id
                                )
                            }
                            .offset(y: 16)
                        }
                        Spacer()
                            .frame(
                                height: 32
                            )
                        if !self.commonViewModel.myCards.contains(
                            where: { $0.id == self.commonViewModel.teamMainModel.owner_card_id}
                        ) && self.viewModel.teamType != .userCard {
                            CustomButtonView(
                                text: "Покинуть команду",
                                color: Color(
                                    red: 0.898,
                                    green: 0.271,
                                    blue: 0.267
                                )
                            )
                            .onTapGesture {
                                self.viewModel.openLeaveAlert()
                            }
                            .customAlert(
                                "Покинуть команду?",
                                isPresented: $viewModel.isLeave,
                                actionText: "Покинуть"
                            ) {
                                self.viewModel.leave()
                            } message: {
                                Text("Вы покинете команду")
                            }
                        }
                    }
                    .padding([.horizontal], 20)
                    Spacer()
                        .frame(
                            height: 154 + self.safeAreaInsets.bottom
                        )
                }
            }
            if self.viewModel.teamType == .userCard {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color(
                                red: 0.973,
                                green: 0.404,
                                blue: 0.4
                            ))
                            .frame(
                                width: 56,
                                height: 56
                            )
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                    .onTapGesture {
                        self.viewModel.dislike(id: "")
                    }
                    Spacer()
                        .frame(width: 16)
                    ZStack {
                        Circle()
                            .fill(Color(
                                red: 0.408,
                                green: 0.784,
                                blue: 0.58
                            ))
                            .frame(
                                width: 56,
                                height: 56
                            )
                        Image(systemName: "heart")
                            .foregroundColor(.white)
                    }
                    .onTapGesture {
                        self.commonViewModel.like(
                            id: self.viewModel.teamId
                        )
                    }
                }
                .offset(
                    x: -20,
                    y: -78 - self.safeAreaInsets.bottom
                )
            }
        }
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
                    width: UIScreen.main.bounds.size.width - 80
                )
                .frame(
                    width: UIScreen.main.bounds.size.width - 160
                )
                .onTapGesture {
                    self.viewModel.createCard()
                }
            }
        )
    }
}

