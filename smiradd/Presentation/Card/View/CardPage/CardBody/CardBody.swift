import SwiftUI
import PhotosUI
import Combine

struct CardBodyView: View {
    @EnvironmentObject var router: NavigationService
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @EnvironmentObject var viewModel: CardViewModel
    
    @State private var isAlert: Bool = false
    
    @State private var imageMock: UIImage?
    @State private var videoMock: URL?
    
    @State private var imageUrl: String = ""
    
    @State private var phone = ""
    
    var body: some View {
        ZStack (alignment: .bottomTrailing) {
            ClampingScrollView {
                VStack (alignment: .leading) {
                    CardImageView(
                        image: self.$imageMock,
                        videoUrl: self.$videoMock,
                        imageUrl: self.$imageUrl,
                        showTrailing: true,
                        editButton: self.viewModel.cardType == .myCard ? true : nil,
                        onTapEditButton: {
                            self.viewModel.changeCardType()
                        }
                    )
                    .onAppear {
                        self.imageUrl = self.viewModel.avatarUrl
                    }
                    VStack (alignment: .leading) {
                        Spacer()
                            .frame(height: 16)
                        CardLogo(cardModel: self.viewModel.cardModel)
                        if self.viewModel.cardModel.phone != nil {
                            CardTileView(
                                icon: "phone_icon",
                                text: CustomFormatter.formatPhoneNumber(
                                    self.viewModel.cardModel.phone!
                                ),
                                isUrl: false
                            )
                            Spacer()
                                .frame(height: 8)
                        }
                        CardTileView(
                            icon: "email",
                            text: self.viewModel.cardModel.email,
                            isUrl: false
                        )
                        Spacer()
                            .frame(height: 8)
                        if self.viewModel.cardModel.address != nil {
                            CardTileView(
                                icon: "address",
                                text: self.viewModel.cardModel.address!,
                                isUrl: false
                            )
                            Spacer()
                                .frame(height: 8)
                        }
                        Spacer()
                            .frame(width: 8)
                        HStack {
                            if self.viewModel.cardModel.tg_url != nil && !self.viewModel.cardModel.tg_url!.isEmpty {
                                if !self.viewModel.cardModel.tg_url!.isEmpty {
                                    Link(
                                        destination: URL(
                                            string: self.viewModel.cardModel.tg_url!
                                        )!
                                    ) {
                                        CustomIconView(
                                            icon: "telegram",
                                            black: false
                                        )
                                    }
                                    Spacer()
                                        .frame(width: 16)
                                }
                            }
                            if self.viewModel.cardModel.vk_url != nil && !self.viewModel.cardModel.vk_url!.isEmpty {
                                if !self.viewModel.cardModel.vk_url!.isEmpty {
                                    Link(
                                        destination: URL(
                                            string: self.viewModel.cardModel.vk_url!
                                        )!
                                    ) {
                                        CustomIconView(
                                            icon: "vk",
                                            black: false
                                        )
                                    }
                                    Spacer()
                                        .frame(width: 16)
                                }
                            }
                            if self.viewModel.cardModel.fb_url != nil {
                                Link(
                                    destination: URL(
                                        string: self.viewModel.cardModel.fb_url!
                                    )!
                                ) {
                                    CustomIconView(
                                        icon: "facebook",
                                        black: false
                                    )
                                }
                                Spacer()
                                    .frame(width: 16)
                            }
                            if self.viewModel.cardModel.phone != nil && !self.viewModel.cardModel.phone!.isEmpty {
                                if !self.viewModel.cardModel.phone!.isEmpty {
                                    Link(
                                        destination: URL(
                                            string: "tel:\(self.phone)"
                                        )!
                                    ) {
                                        CustomIconView(
                                            icon: "phone",
                                            black: false
                                        )
                                    }
                                }
                            }
                        }
                        Spacer()
                            .frame(height: 16)
                        if self.viewModel.cardModel.bio != nil {
                            if !self.viewModel.cardModel.bio!.isEmpty {
                                CardBio(
                                    title: "О команде",
                                    bio: self.viewModel.cardModel.bio!
                                )
                                Spacer()
                                    .frame(height: 16)
                            }
                        }
                        if self.viewModel.cardModel.cv_url != nil {
                            if !self.viewModel.cardModel.cv_url!.isEmpty {
                                CustomTextView(text: "Доп. материалы")
                                Spacer()
                                    .frame(height: 8)
                                CardTileView(
                                    icon: "cv",
                                    text: self.viewModel.cardModel.cv_url!,
                                    isUrl: true
                                )
                                Spacer()
                                    .frame(height: 16)
                            }
                        }
                    }
                    .padding([.horizontal], 20)
                    if self.viewModel.cardModel.services != nil && !self.viewModel.cardModel.services!.isEmpty {
                        if !self.viewModel.cardModel.services!.isEmpty {
                            VStack (alignment: .leading) {
                                CustomTextView(text: "Услуги")
                                Spacer()
                                    .frame(height: 12)
                            }
                            .padding([.horizontal], 20)
                            Spacer()
                                .frame(height: 12)
                            ScrollView(
                                .horizontal,
                                showsIndicators: false
                            ) {
                                HStack {
                                    Spacer()
                                        .frame(width: 20)
                                    ForEach(
                                        Array(
                                            self.viewModel.cardModel.services!.enumerated()
                                        ),
                                        id: \.offset
                                    ) {
                                        index, service in
                                        CardServiceView(service: service)
                                    }
                                }
                            }
                            Spacer()
                                .frame(height: 16)
                        }
                    }
                    if self.viewModel.cardModel.achievements != nil {
                        if !self.viewModel.cardModel.achievements!.isEmpty {
                            VStack (alignment: .leading) {
                                CustomTextView(text: "Достижения")
                                Spacer()
                                    .frame(height: 12)
                            }
                            .padding([.horizontal], 20)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    Spacer()
                                        .frame(width: 20)
                                    ForEach(
                                        Array(
                                            self.viewModel.cardModel.achievements!.enumerated()
                                        ),
                                        id: \.offset
                                    ) {
                                        index, achievement in
                                        if achievement.url == nil {
                                            CardAchievementView(
                                                achievement: achievement
                                            )
                                        }
                                        else {
                                            if achievement.url!.isEmpty {
                                                CardAchievementView(
                                                    achievement: achievement
                                                )
                                            }
                                            else {
                                                Link (
                                                    destination: URL(
                                                        string: achievement.url!
                                                    )!
                                                ) {
                                                    CardAchievementView(
                                                        achievement: achievement
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                            .frame(
                                height: 78 + self.safeAreaInsets.bottom
                            )
                    }
                }
            }
            .refreshable {
                self.viewModel.getCard()
            }
            if self.viewModel.cardType == .userCard {
                HStack {
                    Spacer()
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
                        self.viewModel.dislike()
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
                        self.viewModel.like()
                    }
                }
                .offset(
                    x: -20,
                    y: -78 - self.safeAreaInsets.bottom
                )
            }
        }
        .onAppear {
            if self.viewModel.cardModel.phone != nil && !self.viewModel.cardModel.phone!.isEmpty {
                self.phone = self.viewModel.cardModel.phone!.replacingOccurrences(
                    of: "+",
                    with: "",
                    options: .literal,
                    range: nil
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
