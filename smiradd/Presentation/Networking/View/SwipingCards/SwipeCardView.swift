import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct SwipeCardView: View {
    var cardModel: CardModel
    let onDislike: (() -> ())
    let onLike: (() -> ())
    let onOpen: (() -> ())
    
    @EnvironmentObject var router: NavigationService
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        ZStack {
            VStack {
                if self.cardModel.avatar_url == nil {
                    Image("avatar")
                        .resizable()
                        .frame(
                            height: (UIScreen.main.bounds.size.height - 153 - self.safeAreaInsets.top - self.safeAreaInsets.bottom) / 2)
                }
                else {
                    if self.cardModel.avatar_url!.isEmpty {
                        Image("avatar")
                            .resizable()
                            .frame(
                                height: (UIScreen.main.bounds.size.height - 153 - self.safeAreaInsets.top - self.safeAreaInsets.bottom) / 2)
                    }
                    else {
                        WebImage(
                            url: URL(
                                string: cardModel.avatar_url!
                            )
                        ) { image in
                                image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(
                                    height: (UIScreen.main.bounds.size.height - 153 - safeAreaInsets.top - safeAreaInsets.bottom) / 2
                                )
                                .clipped()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(
                                height: (UIScreen.main.bounds.size.height - 153 - safeAreaInsets.top - safeAreaInsets.bottom) / 2
                            )
                    }
                }
                VStack (alignment: .leading) {
                    Spacer()
                        .frame(height: 16)
                    CardLogo(cardModel: cardModel)
                    if self.cardModel.bio != nil {
                        if !self.cardModel.bio!.isEmpty {
                            CardBio(
                                title: "О себе",
                                bio: cardModel.bio!
                            )
                        }
                    }
                    Spacer()
                    Spacer()
                        .frame(height: 16)
                    CardButtons(
                        cardId: cardModel.id,
                        onDislike: {
                            self.onDislike()
                        },
                        onLike: {
                            self.onLike()
                        }
                    )
                }
                .padding(
                    [.horizontal, .vertical],
                    16
                )
            }
        }
        .frame(
            width: UIScreen.main.bounds.width - 40,
            height: UIScreen.main.bounds.height - 152 - safeAreaInsets.top - safeAreaInsets.bottom
        )
        .background(.white)
        .cornerRadius(16)
        .onTapGesture {
            self.onOpen()
        }
    }
}
