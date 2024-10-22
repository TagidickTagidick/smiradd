import SwiftUI

struct CardAchievementsTileView: View {
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @EnvironmentObject var viewModel: CardViewModel
    
    var body: some View {
        HStack {
            CustomTextView(text: "Достижения")
                .padding(
                    [.horizontal],
                    20
                )
            Spacer()
        }
        Spacer()
            .frame(height: 12)
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
                .onTapGesture {
                    self.viewModel.openAchivement(index: -1)
                }
                Spacer()
                    .frame(width: 12)
                ForEach(
                    Array(self.commonViewModel.achievements.enumerated()),
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
