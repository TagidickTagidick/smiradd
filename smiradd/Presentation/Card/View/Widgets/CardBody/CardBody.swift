import SwiftUI
import PhotosUI
import Combine

struct CardBody: View {
    @EnvironmentObject var router: NavigationService
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @EnvironmentObject var cardSettings: CardViewModel
    
    @State private var isAlert: Bool = false
    
    var body: some View {
        ZStack (alignment: .bottomTrailing) {
            ScrollView {
                VStack (alignment: .leading) {
                    ZStack {
                        if cardSettings.cardModel.avatar_url == nil {
                            Image("avatar")
                                .resizable()
                                .frame(
                                    width: UIScreen.main.bounds.width,
                                    height: 360
                                    )
                        }
                        else {
                            AsyncImage(
                                url: URL(
                                    string: cardSettings.cardModel.avatar_url!
                                )
                            ) { image in
                                image
                                    .resizable()
                                    .frame(
                                        width: UIScreen.main.bounds.width,
                                        height: 360
                                        )
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(height: 228)
                        }
                        VStack {
                            Spacer()
                                .frame(height: safeAreaInsets.top)
                            HStack {
                                BackButton()
                                Spacer()
                                ZStack {
                                    Circle()
                                        .fill(.white.opacity(0.4))
                                        .frame(
                                            width: 48,
                                            height: 48
                                        )
                                    if cardSettings.cardType == .favoriteCard {
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(textDefault)
                                            .onTapGesture {
                                                isAlert = true
                                            }
                                            .customAlert(
                                                            "Удалить из избранного?",
                                                            isPresented: $isAlert,
                                                            actionText: "Удалить"
                                                        ) {
//                                                            makeRequest(
//                                                                path: "cards/\(cardSettings.cardId)/favorites",
//                                                                method: .delete
//                                                            ) { (result: Result<DetailsModel, Error>) in
//                                                                DispatchQueue.main.async {
//                                                                    switch result {
//                                                                    case .success(_):
//                                                                        router.navigateBack()
//                                                                    case .failure(_):
//                                                                        router.navigateBack()
//                                                                    }
//                                                                }
//                                                            }
                                                        } message: {
                                                            Text("Визитка будет удалена, если у вас нет контактов ее владельца, то вернуть ее можно будет только при личной встрече. Удалить визитку из избранного?")
                                                        }
                                    }
                                }
                            }
                            Spacer()
                            if cardSettings.cardType == .myCard {
                                ZStack {
                                    HStack {
                                        Image("edit")
                                        Spacer()
                                            .frame(width: 10)
                                        Text("Редактировать")
                                            .font(
                                                .custom(
                                                    "OpenSans-SemiBold",
                                                    size: 16
                                                )
                                            )
                                            .foregroundStyle(textDefault)
                                    }
                                    .frame(
                                        minWidth: UIScreen.main.bounds.width - 40,
                                        minHeight: 48
                                    )
                                    .background(.white.opacity(0.4))
                                    .cornerRadius(28)
                                }
                                .onTapGesture {
                                    self.cardSettings.cardType = .editCard
                                }
                            }
                        }
                        .padding(
                            [.vertical, .horizontal],
                            20
                        )
                    }
                    .frame(height: 360)
                    VStack (alignment: .leading) {
                        Spacer()
                            .frame(height: 16)
                        CardLogo(cardModel: cardSettings.cardModel)
                        if cardSettings.cardModel.phone != nil {
                            CardTile(
                                icon: "phone",
                                text: CustomFormatter.formatPhoneNumber(cardSettings.cardModel.phone!),
                                isUrl: false
                            )
                            Spacer()
                                .frame(height: 8)
                        }
                        CardTile(
                            icon: "email",
                            text: cardSettings.cardModel.email,
                            isUrl: false
                        )
                        Spacer()
                            .frame(height: 8)
                        if cardSettings.cardModel.seek != nil {
                            CardTile(
                                icon: "site",
                                text: cardSettings.cardModel.seek!,
                                isUrl: true
                            )
                            Spacer()
                                .frame(height: 8)
                        }
                        if cardSettings.cardModel.address != nil {
                            CardTile(
                                icon: "address",
                                text: cardSettings.cardModel.address!,
                                isUrl: false
                            )
                            Spacer()
                                .frame(height: 8)
                        }
                        Spacer()
                            .frame(width: 8)
                        HStack {
                            if cardSettings.cardModel.tg_url != nil {
                                Link(destination: URL(string: cardSettings.cardModel.tg_url!)!) {
                                    CustomIcon(
                                        icon: "telegram",
                                        black: true
                                    )
                                }
                                Spacer()
                                    .frame(width: 16)
                            }
                            if cardSettings.cardModel.vk_url != nil {
                                Link(destination: URL(string: cardSettings.cardModel.vk_url!)!) {
                                    CustomIcon(
                                        icon: "vk",
                                        black: true
                                    )
                                }
                                Spacer()
                                    .frame(width: 16)
                            }
                            if cardSettings.cardModel.fb_url != nil {
                                Link(destination: URL(string: cardSettings.cardModel.fb_url!)!) {
                                    CustomIcon(
                                        icon: "facebook",
                                        black: true
                                    )
                                }
                                Spacer()
                                    .frame(width: 16)
                            }
                            if cardSettings.cardModel.phone != nil {
                                Link(destination: URL(string: "tel:79969267921")!) {
                                    CustomIcon(
                                        icon: "phone_icon",
                                        black: true
                                    )
                                }
                            }
                        }
                        Spacer()
                            .frame(height: 16)
                        if cardSettings.cardModel.bio != nil {
                            CardBio(bio: cardSettings.cardModel.bio!)
                            Spacer()
                                .frame(height: 16)
                        }
                        if cardSettings.cardModel.cv_url != nil {
                            CustomText(text: "Резюме")
                            Spacer()
                                .frame(height: 8)
                            CardTile(
                                icon: "cv",
                                text: cardSettings.cardModel.cv_url!,
                                isUrl: true
                            )
                            Spacer()
                                .frame(height: 16)
                        }
                        if cardSettings.cardModel.services != nil && !cardSettings.cardModel.services!.isEmpty {
                            CustomText(text: "Услуги")
                            Spacer()
                                .frame(height: 12)
                        }
                    }
                    .padding([.horizontal], 20)
                    if cardSettings.cardModel.services != nil && !cardSettings.cardModel.services!.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                Spacer()
                                    .frame(width: 20)
                                ForEach(Array(cardSettings.cardModel.services!.enumerated()), id: \.offset) { index, service in
                                    //CardServiceView(service: service)
                                }
                            }
                        }
                        Spacer()
                            .frame(height: 16)
                    }
                    if cardSettings.cardModel.achievements != nil && !cardSettings.cardModel.achievements!.isEmpty {
                        VStack (alignment: .leading) {
                            CustomText(text: "Достижения")
                            Spacer()
                                .frame(height: 12)
                        }
                        .padding([.horizontal], 20)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                Spacer()
                                    .frame(width: 20)
                                ForEach(Array(cardSettings.cardModel.achievements!.enumerated()), id: \.offset) {
                                    index, achievement in
                                    CardAchievementView(achievement: achievement)
                                }
                            }
                        }
                    }
                    Spacer()
                        .frame(height: 78)
                }
            }
            if cardSettings.cardType == .userCard {
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
                        makeRequest(
                            path: "cards/\(cardSettings.cardModel.id)/favorites",
                            method: .delete
                        ) { (result: Result<DetailsModel, Error>) in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(_):
                                    router.navigateBack()
                                case .failure(_):
                                    print("failure")
                                }
                            }
                        }
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
                        makeRequest(
                            path: "cards/\(cardSettings.cardModel.id)/favorites",
                            method: .post
                        ) { (result: Result<DetailsModel, Error>) in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(_):
                                    router.navigateBack()
                                case .failure(_):
                                    print("failure")
                                }
                            }
                        }
                    }
                }
                .offset(
                    x: -20,
                    y: -78
                )
            }
        }
    }
}
