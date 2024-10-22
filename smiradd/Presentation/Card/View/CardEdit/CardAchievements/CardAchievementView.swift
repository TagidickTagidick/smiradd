import SwiftUI

struct CardAchievementView: View {
    var achievement: AchievementModel
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            textDefault
            VStack (alignment: .leading) {
                Text(achievement.name)
                    .font(
                        .custom(
                            "OpenSans-SemiBold",
                            size: 16
                        )
                    )
                    .foregroundStyle(.white)
                Spacer()
                    .frame(height: 8)
                Text(achievement.description ?? "")
                    .font(
                        .custom(
                            "OpenSans-Regular",
                            size: 14
                        )
                    )
                    .foregroundStyle(.white)
                Spacer()
                    .frame(height: 12)
                if achievement.url != nil {
                    if !achievement.url!.isEmpty {
                        HStack {
                            Image("site")
                                .renderingMode(.template)
                                .frame(
                                    width: 24,
                                    height: 24
                                )
                                .foregroundColor(.white)
                            Spacer()
                                .frame(width: 8)
                            Text(achievement.url!)
                                .font(
                                    .custom(
                                        "OpenSans-Regular",
                                        size: 14
                                    )
                                )
                                .foregroundStyle(.white)
                                .frame(height: 20)
                        }
                    }
                }
            }
        }
        .padding(
            [.vertical, .horizontal],
            16
        )
        .background(textDefault)
        .frame(
            width: 240,
            height: 160
        )
        .cornerRadius(12)
    }
}
