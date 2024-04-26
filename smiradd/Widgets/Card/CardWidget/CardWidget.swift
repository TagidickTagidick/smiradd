import SwiftUI

struct CardWidget: View {
    var cardModel: CardModel
    
    var body: some View {
        ZStack {
            VStack {
                Image("avatar")
                VStack {
                    HStack {
                        VStack (alignment: .leading) {
                            Text(cardModel.job_title)
                                .font(
                                    .custom(
                                        "OpenSans-SemiBold",
                                        size: 20
                                    )
                                )
                                .foregroundStyle(textDefault)
                            Spacer()
                                .frame(height: 8)
                            Text(cardModel.name)
                                .font(
                                    .custom(
                                        "OpenSans-Medium",
                                        size: 16
                                    )
                                )
                                .foregroundStyle(textDefault)
                        }
                        Spacer()
                        Spacer()
                            .frame(width: 8)
                        Image("avatar")
                            .resizable()
                            .frame(
                                width: 56,
                                height: 56
                            )
                            .cornerRadius(8)
                    }
                    if cardModel.bio != nil {
                        Spacer()
                            .frame(height: 12)
                        Text("О себе")
                            .font(
                                .custom(
                                    "OpenSans-Medium",
                                    size: 14
                                )
                            )
                            .foregroundStyle(textAdditional)
                        Spacer()
                            .frame(height: 8)
                        Text(cardModel.bio!)
                            .font(
                                .custom(
                                    "OpenSans-Regular",
                                    size: 14
                                )
                            )
                            .foregroundStyle(textDefault)
                    }
                    Spacer()
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        Text("100 м отсюда")
                            .font(
                                .custom(
                                    "OpenSans-Regular",
                                    size: 15
                                )
                            )
                            .foregroundStyle(textDefault)
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color(
                                    red: 0.973,
                                    green: 0.404,
                                    blue: 0.4
                                ))
                                .frame(
                                    width: 48,
                                    height: 48
                                )
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                        }
                        ZStack {
                            Circle()
                                .fill(Color(
                                    red: 0.408,
                                    green: 0.784,
                                    blue: 0.58
                                ))
                                .frame(
                                    width: 48,
                                    height: 48
                                )
                            Image(systemName: "heart")
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(
                    [.horizontal, .vertical],
                    16
                )
            }
        }
        .frame(
            maxWidth: UIScreen.main.bounds.width - 40,
            maxHeight: .infinity
        )
        .background(.white)
        .cornerRadius(16)
        .shadow(
            color: Color(
                red: 0.125,
                green: 0.173,
                blue: 0.275,
                opacity: 0.08
            ),
            radius: 16,
            y: 4
        )
    }
}
