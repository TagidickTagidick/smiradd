import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
import NukeUI

struct MyTeamCardView: View {
    let teamMainModel: TeamMainModel
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @State var template: TemplateModel?
    
    var avatars: [String] = []
    
    init(teamMainModel: TeamMainModel) {
        self.teamMainModel = teamMainModel
        
        for teammate in self.teamMainModel.teammates {
            if teammate.avatar_url != nil {
                self.avatars.append(teammate.avatar_url!)
            }
        }
    }
    
    var body: some View {
        ZStack (alignment: .topLeading) {
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
            }
            VStack (alignment: .leading) {
                Text(self.teamMainModel.team.name)
                    .font(
                        .custom(
                            "OpenSans-SemiBold",
                            size: 20
                        )
                    )
                    .foregroundStyle(
                        self.template == nil
                        ? .white
                        : self.template!.theme == "black"
                        ? .white
                        : textDefault
                    )
                Spacer()
                    .frame(height: 8)
                HStack {
                    Image("team")
                        .renderingMode(.template)
                        .frame(
                            width: 20,
                            height: 20
                        )
                        .foregroundColor(self.template == nil
                                         ? .white
                                         : self.template!.theme == "black"
                                         ? .white
                                         : textDefault)
                    Spacer()
                        .frame(
                            width: 10
                        )
                    Text(CustomFormatter.formatMembers(
                        members: self.teamMainModel.teammates.count
                    ))
                        .font(
                            .custom(
                                "OpenSans-Regular",
                                size: 16
                            )
                        )
                        .foregroundStyle(
                            self.template == nil
                            ? .white
                            : self.template!.theme == "black"
                            ? .white
                            : textDefault
                        )
                }
                Spacer()
                HStack {
                    ShareLink(
                        item: URL(
                            string: "https://smiradd.ru/teams/invite/\(self.teamMainModel.team.invite_url)")!
                    ) {
                        CustomIconView(
                            icon: "share",
                            black: self.template == nil
                            ? false
                            : self.template!.theme == "black"
                        )
                    }
                    Spacer()
                        .frame(
                            width: 12
                        )
                    ZStack {
                        ForEach(
                            0..<(self.avatars.count > 3 ? 3 : self.avatars.count),
                            id: \.self
                        ) {
                            index in
                            WebImage(
                                url: URL(
                                    string: self.avatars[index]
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
                                .offset(x: CGFloat(index * 30))
                        }
                    }
                    Spacer()
                }
            }
            .padding(
                [.vertical, .horizontal],
                20
            )
            .frame(
                width: UIScreen.main.bounds.size.width - 40,
                height: 228
            )
        }
        .frame(
            width: UIScreen.main.bounds.size.width - 40,
            height: 228
        )
        .background(textDefault)
        .cornerRadius(20)
        .onAppear {
            if self.teamMainModel.team.bc_template_type != nil {
                self.template = self.commonViewModel.templates.first(
                    where: {
                        $0.id == self.teamMainModel.team.bc_template_type
                    }
                ) ?? nil
            }
        }
    }
}

