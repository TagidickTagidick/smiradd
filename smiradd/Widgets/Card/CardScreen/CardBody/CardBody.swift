import SwiftUI
import PhotosUI
import Combine

struct CardBody: View {
    @EnvironmentObject var router: Router
    
    @State private var pageType: PageType = .loading
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @EnvironmentObject var cardSettings: CardSettings
    
    var body: some View {
        ZStack {
            if pageType == .loading {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding(
                    [.horizontal],
                    20
                )
            }
            else {
                ScrollView {
                    if pageType == .loading {
                        ProgressView()
                    }
                    else {
                        VStack {
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
                                        ZStack {
                                            Circle()
                                                .fill(.white.opacity(0.4))
                                                .frame(
                                                    width: 48,
                                                    height: 48
                                                )
                                            Image(systemName: "arrow.left")
                                                .foregroundColor(textDefault)
                                        }
                                        .onTapGesture {
                                            router.navigateBack()
                                        }
                                        Spacer()
                                        ZStack {
                                            Circle()
                                                .fill(.white.opacity(0.4))
                                                .frame(
                                                    width: 48,
                                                    height: 48
                                                )
                                            Image("unlock")
                                                .foregroundColor(Color(
                                                    red: 0.8,
                                                    green: 0.8,
                                                    blue: 0.8
                                                ))
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
                                            cardSettings.cardType = .editCard
                                        }
                                    }
                                }
                                .padding([.vertical, .horizontal], 20)
                            }
                            .frame(height: 360)
                            VStack (alignment: .leading) {
                                CardLogo(cardModel: cardSettings.cardModel)
                                if cardSettings.cardModel.phone != nil {
                                    CardTile(
                                        icon: "phone",
                                        text: cardSettings.cardModel.phone!
                                    )
                                }
                                CardTile(
                                    icon: "email",
                                    text: cardSettings.cardModel.email
                                )
                                if cardSettings.cardModel.seek != nil {
                                    CardTile(
                                        icon: "site",
                                        text: cardSettings.cardModel.seek!
                                    )
                                }
                                if cardSettings.cardModel.address != nil {
                                    CardTile(
                                        icon: "address",
                                        text: cardSettings.cardModel.address!
                                    )
                                }
                                Spacer()
                                    .frame(width: 16)
                                HStack {
                                    CustomIcon(
                                        icon: "telegram",
                                        black: true
                                    )
                                    Spacer()
                                        .frame(width: 16)
                                    CustomIcon(
                                        icon: "vk",
                                        black: true
                                    )
                                    Spacer()
                                        .frame(width: 16)
                                    CustomIcon(
                                        icon: "facebook",
                                        black: true
                                    )
                                    Spacer()
                                        .frame(width: 16)
                                    CustomIcon(
                                        icon: "phone_icon",
                                        black: true
                                    )
                                }
                                Spacer()
                                    .frame(height: 16)
                                if cardSettings.cardModel.bio != nil {
                                    CardBio(bio: cardSettings.cardModel.bio!)
                                }
                                Spacer()
                                    .frame(height: 16)
                                CustomText(text: "Резюме")
                                Spacer()
                                    .frame(height: 8)
                            }
                            .padding([.horizontal], 20)
                            .padding([.vertical], 16)
                        }
                    }
                }
            }
        }
    }
}
