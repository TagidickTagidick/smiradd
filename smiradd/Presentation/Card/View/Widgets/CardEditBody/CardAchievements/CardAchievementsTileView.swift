import SwiftUI

struct CardAchievementsTileView: View {
    @EnvironmentObject var viewModel: CardViewModel
    
    var body: some View {
        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {
            HStack {
                Spacer()
                    .frame(width: 20)
                ZStack {
                    Image(systemName: "plus")
                        .frame(
                            width: 36,
                            height: 36
                        )
                        .foregroundStyle(textAdditional)
                }
                .frame(
                    width: 160,
                    height: 160
                )
                .background(accent50)
                .cornerRadius(16)
                .onTapGesture {
                    self.viewModel.achievementIndex = -1
                    //router.navigate(to: .achievementScreen)
                }
                Spacer()
                    .frame(width: 12)
                ForEach(
                    Array(self.viewModel.achievements.enumerated()),
                    id: \.offset
                ) {
                    index, achievement in
                    ZStack {
                        CardAchievementView(achievement: achievement)
                        CardButtonView(
                            image: "edit",
                            text: "Изменить"
                        )
                        .padding(
                            [.vertical],
                            9
                        )
                        .padding(
                            [.horizontal],
                            20
                        )
                        .background(.white.opacity(0.6))
                    }
                    .onTapGesture {
                        //                                                self.viewModel.achievementIndex = index
                        //                                                router.navigate(to: .achievementScreen)
                    }
                }
            }
        }
    }
}
