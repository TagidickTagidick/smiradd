import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct NetworkingCardView: View {
    var cardModel: CardModel
    let onDislike: (() -> ())
    let onLike: (() -> ())
    let onOpen: (() -> ())
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        VStack {
            if self.cardModel.avatar_url == nil {
                Image("avatar")
                    .resizable()
                    .frame(
                        height: (UIScreen.main.bounds.size.height - 130 - self.safeAreaInsets.top - self.safeAreaInsets.bottom) / 2)
            }
            else {
                if self.cardModel.avatar_url!.isEmpty {
                    Image("avatar")
                        .resizable()
                        .frame(
                            height: (UIScreen.main.bounds.size.height - 130 - self.safeAreaInsets.top - self.safeAreaInsets.bottom) / 2)
                }
                else {
                    WebImage(
                        url: URL(
                            string: self.cardModel.avatar_url!
                        )
                    ) { image in
                            image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                height: (UIScreen.main.bounds.size.height - 130 - self.safeAreaInsets.top - self.safeAreaInsets.bottom) / 2
                            )
                            .clipped()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(
                            height: (UIScreen.main.bounds.size.height - 130 - self.safeAreaInsets.top - self.safeAreaInsets.bottom) / 2
                        )
                }
            }
            VStack (alignment: .leading) {
                CardLogoView(
                    cardModel: cardModel
                )
                Spacer()
                    .frame(
                        height: 12
                    )
                if !(self.cardModel.seek ?? "").isEmpty && !(self.cardModel.useful ?? "").isEmpty {
                    HStack (
                        alignment: .top
                    ) {
                        CardSeekView(
                            title: "Полезен",
                            text: self.cardModel.useful!
                        )
                        Spacer()
                            .frame(
                                width: 8
                            )
                        Spacer()
                        CardSeekView(
                            isRight: true,
                            title: "Ищу",
                            text: self.cardModel.seek!
                        )
                    }
                }
                else if !(self.cardModel.useful ?? "").isEmpty {
                    CardSeekView(
                        title: "Полезен",
                        text: self.cardModel.useful!
                    )
                }
                else if !(self.cardModel.seek ?? "").isEmpty {
                    CardSeekView(
                        title: "Ищу",
                        text: self.cardModel.seek!
                    )
                }
                else if !(self.cardModel.bio ?? "").isEmpty {
                    CardBioView(
                        title: "О себе",
                        bio: cardModel.bio!,
                        showButton: false
                    )
                }
                Spacer()
                Spacer()
                    .frame(height: 16)
                CardButtonsView(
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
                [.all],
                16
            )
        }
        .frame(
            width: UIScreen.main.bounds.width - 40,
            height: UIScreen.main.bounds.height - 152 - self.safeAreaInsets.top - self.safeAreaInsets.bottom
        )
        .background(.white)
        .cornerRadius(16)
        .onTapGesture {
            self.onOpen()
        }
    }
}
