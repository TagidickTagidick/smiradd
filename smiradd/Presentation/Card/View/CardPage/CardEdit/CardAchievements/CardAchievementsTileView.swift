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
                CardPlusButtonView(
                    height: 160
                )
                    .navigationDestination(
                        isPresented: $viewModel.achievementsOpened
                    ) {
                        AchievementPageView(
                            index: self.viewModel.achievementIndex,
                            cardViewModel: self.viewModel
                        )
                        .environmentObject(self.viewModel)
                    }
                .onTapGesture {
                    self.viewModel.openAchivement(index: -1)
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
                        .cornerRadius(28)
                    }
                    .onTapGesture {
                        self.viewModel.openAchivement(index: index)
                    }
                }
            }
        }
    }
}
