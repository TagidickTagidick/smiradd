import SwiftUI
import PhotosUI
import Combine
import CardStack

struct CardBodyView: View {
    @EnvironmentObject var router: NavigationService
    
    @EnvironmentObject private var navigationService: NavigationService
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @EnvironmentObject var viewModel: CardViewModel
    
    @State private var isAlert: Bool = false
    
    @State private var imageMock: UIImage?
    @State private var videoMock: URL?
    
    @State private var imageUrl: String = ""
    
    @State private var phone = ""
    
    @Namespace var namespace
    
    var body: some View {
        ZStack (alignment: .bottomTrailing) {
            ScrollView {
                VStack (alignment: .leading) {
                    CardImageView(
                        image: self.$imageMock,
                        video: self.$videoMock,
                        imageUrl: self.$imageUrl,
                        trailing: self.commonViewModel.myCards.first(
                            where: {
                                $0.id == self.viewModel.cardId
                            }
                        ) == nil ? self.commonViewModel.cardModel.like == true ? "favorites_active" : "favorites" : self.commonViewModel.cardModel.is_default == true ? "lock" : "unlock",
                        onTapTrailing: {
                            if self.commonViewModel.myCards.first(
                                where: {
                                    $0.id == self.viewModel.cardId
                                }
                            ) == nil {
                                if self.commonViewModel.cardModel.like == true {
                                    self.viewModel.openDeleteFromFavoritesAlert()
                                }
                                else {
                                    self.navigationService.navigateBack()
                                    
                                    if self.viewModel.cardType == .networkingUserCard {
                                        withAnimation {
                                            self.commonViewModel.networkingCards.swipe(
                                                direction: .right,
                                                completion: nil
                                            )
                                        }
                                    }
                                    
                                    self.commonViewModel.like(
                                        id: self.viewModel.cardId
                                    )
                                }
                            }
                            else {
                                self.viewModel.changeIsDefault(
                                    isDefault: self.commonViewModel.cardModel.is_default == true
                                )
                            }
                        },
                        editButton: self.commonViewModel.myCards.first(
                            where: {
                                $0.id == self.viewModel.cardId
                            }
                        ) == nil ? nil : true,
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
                        CardLogoView(
                            cardModel: self.commonViewModel.cardModel
                        )
                        if self.commonViewModel.cardModel.phone != nil {
                            CardTileView(
                                icon: "phone_icon",
                                text: CustomFormatter.formatPhoneNumber(
                                    self.commonViewModel.cardModel.phone!
                                ),
                                isUrl: false
                            )
                            Spacer()
                                .frame(height: 8)
                        }
                        CardTileView(
                            icon: "email",
                            text: self.commonViewModel.cardModel.email,
                            isUrl: false
                        )
                        Spacer()
                            .frame(height: 8)
                        if self.commonViewModel.cardModel.address != nil {
                            CardTileView(
                                icon: "address",
                                text: self.commonViewModel.cardModel.address!,
                                isUrl: false
                            )
                            Spacer()
                                .frame(height: 8)
                        }
                        Spacer()
                            .frame(width: 8)
                        HStack {
                            if self.commonViewModel.cardModel.tg_url != nil && !self.commonViewModel.cardModel.tg_url!.isEmpty {
                                if !self.commonViewModel.cardModel.tg_url!.isEmpty {
                                    Link(
                                        destination: URL(
                                            string: self.commonViewModel.cardModel.tg_url!
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
                            if self.commonViewModel.cardModel.vk_url != nil {
                                if !self.commonViewModel.cardModel.vk_url!.isEmpty {
                                    Link(
                                        destination: URL(
                                            string: self.commonViewModel.cardModel.vk_url!
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
                            if self.commonViewModel.cardModel.fb_url != nil {
                                Link(
                                    destination: URL(
                                        string: self.commonViewModel.cardModel.fb_url!
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
                            if self.commonViewModel.cardModel.phone != nil && !self.commonViewModel.cardModel.phone!.isEmpty {
                                if !self.commonViewModel.cardModel.phone!.isEmpty {
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
                        if self.commonViewModel.cardModel.useful != nil {
                            if !self.commonViewModel.cardModel.useful!.isEmpty {
                                CardSeekView(
                                    title: "Ищу",
                                    text: self.commonViewModel.cardModel.useful!
                                )
                                Spacer()
                                    .frame(height: 16)
                            }
                        }
                        if self.commonViewModel.cardModel.seek != nil {
                            if !self.commonViewModel.cardModel.seek!.isEmpty {
                                CardSeekView(
                                    title: "Полезен",
                                    text: self.commonViewModel.cardModel.seek!
                                )
                                Spacer()
                                    .frame(height: 16)
                            }
                        }
                        if self.commonViewModel.cardModel.bio != nil {
                            if !self.commonViewModel.cardModel.bio!.isEmpty {
                                CardBioView(
                                    title: "О команде",
                                    bio: self.commonViewModel.cardModel.bio!,
                                    showButton: true
                                )
                                Spacer()
                                    .frame(height: 16)
                            }
                        }
                        if self.commonViewModel.cardModel.cv_url != nil {
                            if !self.commonViewModel.cardModel.cv_url!.isEmpty {
                                CustomTextView(text: "Доп. материалы")
                                Spacer()
                                    .frame(height: 8)
                                CardTileView(
                                    icon: "cv",
                                    text: self.commonViewModel.cardModel.cv_url!,
                                    isUrl: true
                                )
                                Spacer()
                                    .frame(height: 16)
                            }
                        }
                    }
                    .padding([.horizontal], 20)
                    if self.commonViewModel.cardModel.services != nil {
                        if !self.commonViewModel.cardModel.services!.isEmpty {
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
                                            self.commonViewModel.cardModel.services!.enumerated()
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
                    if self.commonViewModel.cardModel.achievements != nil {
                        if !self.commonViewModel.cardModel.achievements!.isEmpty {
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
                                            self.commonViewModel.cardModel.achievements!.enumerated()
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
                                height: 154 + self.safeAreaInsets.bottom
                            )
                    }
                }
                .background(.white)
            }
            .refreshable {
                self.viewModel.getCard()
            }
            if self.commonViewModel.myCards.first(
                where: {
                    $0.id == self.viewModel.cardId
                }
            ) == nil {
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
                        if self.commonViewModel.cardModel.like == true {
                            self.viewModel.openDeleteFromFavoritesAlert()
                            
                            return
                        }
                        
                        self.navigationService.navigateBack()
                        
                        if self.viewModel.cardType == .networkingUserCard {
                            withAnimation {
                                self.commonViewModel.networkingCards.swipe(
                                    direction: .left,
                                    completion: nil
                                )
                            }
                        }
                        
                        self.commonViewModel.dislike(
                            id: self.viewModel.cardId
                        )
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
                        if self.commonViewModel.cardModel.like == true {
                            withAnimation {
                                self.commonViewModel.showAlert(
                                    isError: true,
                                    text: "Визитка уже добавлена в избранное"
                                )
                            }
                            
                            return
                        }
                        
                        self.navigationService.navigateBack()
                        
                        if self.viewModel.cardType == .networkingUserCard {
                            withAnimation {
                                self.commonViewModel.networkingCards.swipe(
                                    direction: .right,
                                    completion: nil
                                )
                            }
                        }
                        
                        self.commonViewModel.like(
                            id: self.viewModel.cardId
                        )
                    }
                }
                .offset(
                    x: -20,
                    y: -78 - self.safeAreaInsets.bottom
                )
            }
        }
        .onAppear {
            if !(self.commonViewModel.cardModel.phone ?? "").isEmpty {
                self.phone = self.commonViewModel.cardModel.phone!.replacingOccurrences(
                    of: "+",
                    with: "",
                    options: .literal,
                    range: nil
                )
                print(phone)
            }
        }
        .customAlert(
            "Удалить из избранного?",
            isPresented: self.$viewModel.isDeleteFromFavorites,
            actionText: "Удалить"
        ) {
            self.viewModel.deleteFromFavorites()
        } message: {
            Text("Визитка будет удалена, если у вас нет контактов ее владельца, то вернуть ее можно будет только при личной встрече. Удалить визитку из избранного?")
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
