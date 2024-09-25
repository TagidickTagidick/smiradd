import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct SwipeTeamView: View {
    var teamModel: TeamModel
    let onDislike: (() -> ())
    let onLike: (() -> ())
    let onOpen: (() -> ())
    
    @EnvironmentObject var router: NavigationService
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        VStack (alignment: .leading) {
            if self.teamModel.team_logo == nil {
                Image("avatar")
                    .resizable()
                    .frame(
                        height: (UIScreen.main.bounds.size.height - 153 - self.safeAreaInsets.top - self.safeAreaInsets.bottom) / 2)
            }
            else {
                if self.teamModel.team_logo!.isEmpty {
                    Image("avatar")
                        .resizable()
                        .frame(
                            height: (UIScreen.main.bounds.size.height - 153 - self.safeAreaInsets.top - self.safeAreaInsets.bottom) / 2)
                }
                else {
                    WebImage(
                        url: URL(
                            string: self.teamModel.team_logo!
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
                            height: (UIScreen.main.bounds.size.height - 153 - self.safeAreaInsets.top - self.safeAreaInsets.bottom) / 2
                        )
                }
            }
            VStack (alignment: .leading) {
                Spacer()
                    .frame(height: 16)
                Text(teamModel.name)
                    .font(
                        .custom(
                            "OpenSans-SemiBold",
                            size: 24
                        )
                    )
                    .foregroundStyle(textDefault)
                Spacer()
                    .frame(height: 12)
                if self.teamModel.about_team != nil {
                    CardBio(
                        title: "О команде",
                        bio: self.teamModel.about_team!
                    )
                }
                Spacer()
                CardButtons(
                    cardId: teamModel.id!,
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
