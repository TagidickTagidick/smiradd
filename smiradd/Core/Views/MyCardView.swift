import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
import NukeUI

struct MyCardView: View {
    let cardModel: CardModel
    let isMyCard: Bool
    var onDislike: ((String) -> ())? = nil
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @State var template: TemplateModel?
    
    @State private var phone: String = ""
    
    @EnvironmentObject private var navigationService: NavigationService
    
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            if self.template != nil {
                LazyImage(
                    url: URL(
                        string: self.template!.picture_url!.replacingOccurrences(
                            of: "\\",
                            with: ""
                        )
                    )
                ) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .frame(
                                width: UIScreen.main.bounds.size.width - 40,
                                height: 228
                            )
                            .clipped()
                    } else {
                        Color.gray.opacity(0.2)
                    }
                }
                .frame(height: 228)
//                AsyncImage(
//                    url: URL(
//                        string: self.template!.picture_url!.replacingOccurrences(
//                            of: "\\",
//                            with: ""
//                        )
//                    )
//                ) { image in
//                    image
//                        .resizable()
//                        .frame(height: 228)
//                } placeholder: {
//                    ProgressView()
//                }
//                .frame(height: 228)
            }
            VStack (alignment: .leading) {
                HStack {
                    if self.cardModel.avatar_url == nil {
                        Image("avatar")
                            .resizable()
                            .frame(
                                width: 52,
                                height: 52
                            )
                            .clipShape(Circle())
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
                                    width: 52,
                                    height: 52
                                )
                                .clipped()
                                .clipShape(Circle())
                            } placeholder: {
                                    Rectangle().foregroundColor(.gray)
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
                        Text(self.cardModel.job_title)
                            .font(
                                .custom(
                                    "OpenSans-SemiBold",
                                    size: 20
                                )
                            )
                            .foregroundStyle(
                                self.template == nil
                                ? .white
                                : template!.theme == "black"
                                ? .white
                                : textDefault
                            )
                        Spacer()
                            .frame(height: 8)
                        Text(self.cardModel.name)
                            .font(
                                .custom(
                                    "OpenSans-Regular",
                                    size: 16
                                )
                            )
                            .foregroundStyle(
                                self.template == nil
                                ? .white
                                : template!.theme == "black"
                                ? .white
                                : textDefault
                            )
                    }
                }
                Spacer()
                    .frame(height: 16)
                HStack {
                    VStack (alignment: .leading) {
                        Text(self.cardModel.phone ?? "")
                            .font(
                                .custom(
                                    "OpenSans-Regular",
                                    size: 16
                                )
                            )
                            .foregroundStyle(
                                self.template == nil
                                ? .white
                                : template!.theme == "black"
                                ? .white
                                : textDefault
                            )
                        Spacer()
                            .frame(height: 8)
                        Text(self.cardModel.email)
                            .font(
                                .custom(
                                    "OpenSans-Regular",
                                    size: 16
                                )
                            )
                            .foregroundStyle(
                                self.template == nil
                                ? .white
                                : template!.theme == "black"
                                ? .white
                                : textDefault
                            )
                    }
                    Spacer()
                    Spacer()
                        .frame(width: 20)
                    if self.cardModel.company_logo != nil {
                        WebImage(
                            url: URL(
                                string: self.cardModel.company_logo!
                            )
                        ) { image in
                                image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(
                                    width: 48,
                                    height: 48
                                )
                                .clipped()
                                .cornerRadius(12)
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
                if self.isMyCard {
                    HStack {
                        ShareLink(
                            item: URL(
                                string: "https://smiradd.ru/cards/\(self.cardModel.id)"
                            )!
                        ) {
                            CustomIconView(
                                icon: "share",
                                black: self.template == nil
                                ? true
                                : self.template!.theme == "black"
                            )
                        }
                        Spacer()
                            .frame(width: 16)
                        CustomIconView(
                            icon: "qr_scan",
                            black: self.template == nil
                            ? true
                            : self.template!.theme == "black"
                        )
                        .onTapGesture {
                            self.navigationService.navigate(
                                to: .qrCodeScreen(
                                    id: self.cardModel.id,
                                    bcTemplateType: self.cardModel.bc_template_type,
                                    jobTitle: self.cardModel.job_title
                                )
                            )
                        }
                        Spacer()
                        CustomIconView(
                            icon: "lock",
                            black: self.template == nil
                            ? true
                            : self.template!.theme == "black"
                        )
                        
                    }
                }
                else {
                    HStack {
                        if self.cardModel.tg_url != nil && self.cardModel.tg_url != "" {
                            Link (
                                destination: URL(
                                    string: self.cardModel.tg_url!
                                )!
                            ) {
                                CustomIconView(
                                    icon: "telegram",
                                    black: self.template == nil
                                    ? true
                                    : self.template!.theme == "black"
                                )
                            }
                            Spacer()
                                .frame(width: 16)
                        }
                        if self.cardModel.vk_url != nil && self.cardModel.vk_url != "" {
                            Link (
                                destination: URL(
                                    string: self.cardModel.vk_url!
                                )!
                            ) {
                                CustomIconView(
                                    icon: "vk",
                                    black: self.template == nil
                                    ? true
                                    : self.template!.theme == "black"
                                )
                            }
                            Spacer()
                                .frame(width: 16)
                        }
                        if self.cardModel.phone != nil && self.cardModel.phone != "" {
                            Link (
                                destination: URL(
                                    string: "tel:\(self.phone)"
                                )!
                            ) {
                                CustomIconView(
                                    icon: "phone",
                                    black: self.template == nil
                                    ? true
                                    : self.template!.theme == "black"
                                )
                            }
                            Spacer()
                                .frame(width: 16)
                        }
                        Spacer()
                        CustomIconView(
                            icon: "favorites_active",
                            black: self.template == nil
                            ? true
                            : self.template!.theme == "black"
                        )
                        .onTapGesture {
                            if self.onDislike != nil {
                                self.onDislike!(cardModel.id)
                            }
                        }
                    }
                }
            }
            .padding(
                [.vertical, .horizontal],
                20
            )
        }
        .frame(
            width: UIScreen.main.bounds.size.width - 40,
            height: 228
        )
        .background(textDefault)
        .cornerRadius(20)
        .onAppear {
            if self.cardModel.bc_template_type != nil {
                self.template = self.commonViewModel.templates.first(
                    where: { $0.id == self.cardModel.bc_template_type }
                ) ?? nil
            }
            
            if !(self.cardModel.phone ?? "").isEmpty {
                self.phone = self.cardModel.phone!.replacingOccurrences(
                    of: "+",
                    with: "",
                    options: .literal,
                    range: nil
                )
            }
        }
    }
}

