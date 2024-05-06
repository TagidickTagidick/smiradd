import SwiftUI

struct MyCard: View {
    var cardModel: CardModel
    
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var cardSettings: CardSettings
    @EnvironmentObject private var profileSettings: ProfileSettings
    
    @State private var template: TemplateModel?
    
    var body: some View {
        ZStack {
            if template != nil {
                AsyncImage(
                    url: URL(
                        string: template!.picture_url!.replacingOccurrences(of: "\\", with: "")
                    )
                ) { image in
                    image
                        .resizable()
                        .frame(height: 228)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 228)
            }
            VStack (alignment: .leading) {
                HStack {
                    if cardModel.avatar_url == nil {
                        Image("avatar")
                            .resizable()
                            .frame(
                                width: 52,
                                height: 52
                            )
                            .clipShape(Circle())
                    }
                    else {
                        AsyncImage(
                            url: URL(
                                string: cardModel.avatar_url!
                            )
                        ) { image in
                            image
                                .resizable()
                                .frame(
                                    width: 52,
                                    height: 52
                                )
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(
                            width: 52,
                            height: 52
                        )
                        .clipShape(Circle())
                    }
                    Spacer()
                        .frame(width: 16)
                    VStack (alignment: .leading) {
                        Text(cardModel.job_title)
                            .font(
                                .custom(
                                    "OpenSans-SemiBold",
                                    size: 20
                                )
                            )
                            .foregroundStyle(
                                template == nil
                                ? .white
                                : template!.theme == "black"
                                ? textDefault
                                : .white
                            )
                        Spacer()
                            .frame(height: 8)
                        Text(cardModel.name)
                            .font(
                                .custom(
                                    "OpenSans-Regular",
                                    size: 16
                                )
                            )
                            .foregroundStyle(
                                template == nil
                                ? .white
                                : template!.theme == "black"
                                ? textDefault
                                : .white
                            )
                    }
                }
                Spacer()
                    .frame(height: 16)
                HStack {
                    VStack (alignment: .leading) {
                        Text(cardModel.phone ?? "")
                            .font(
                                .custom(
                                    "OpenSans-Regular",
                                    size: 16
                                )
                            )
                            .foregroundStyle(
                                template == nil
                                ? .white
                                : template!.theme == "black"
                                ? textDefault
                                : .white
                            )
                        Spacer()
                            .frame(height: 8)
                        Text(cardModel.email)
                            .font(
                                .custom(
                                    "OpenSans-Regular",
                                    size: 16
                                )
                            )
                            .foregroundStyle(
                                template == nil
                                ? .white
                                : template!.theme == "black"
                                ? textDefault
                                : .white
                            )
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 20)
                    if cardModel.company_logo != nil {
                        AsyncImage(
                            url: URL(
                                string: cardModel.company_logo!
                            )
                        ) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(
                            width: 48,
                            height: 48
                        )
                        .cornerRadius(12)
                    }
                }
                Spacer()
                    .frame(height: 16)
                HStack {
                    ShareLink(item: URL(string: "https://vizme.pro/cards/\(cardModel.id)")!) {
                        CustomIcon(
                            icon: "share",
                            black: template == nil
                            ? false
                            : template!.theme == "black"
                        )
                    }
                    Spacer()
                        .frame(width: 16)
                    CustomIcon(
                        icon: "qr_scan",
                        black: template == nil
                        ? false
                        : template!.theme == "black"
                    )
                    .onTapGesture {
                        cardSettings.cardModel = cardModel
                        router.navigate(to: .qrCodeScreen)
                    }
                    Spacer()
                    CustomIcon(
                        icon: "lock",
                        black: template == nil
                        ? false
                        : template!.theme == "black"
                    )
                }
            }
            .padding(
                [.vertical, .horizontal],
                20
            )
            .frame(height: 228)
        }
        .frame(height: 228)
        .background(textDefault)
        .cornerRadius(20)
        .onAppear {
            if cardModel.bc_template_type != nil {
                template = profileSettings.templates.first(where: { $0.id == cardModel.bc_template_type }) ?? nil
            }
        }
    }
}

