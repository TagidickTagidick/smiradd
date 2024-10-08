import SwiftUI
import Shimmer

struct CardShimmerView: View {
    var body: some View {
        VStack (alignment: .leading) {
            Image("avatar")
                .frame(
                    width: UIScreen.main.bounds.size.width,
                    height: 360
                )
            VStack (alignment: .leading) {
                Spacer()
                    .frame(height: 16)
                CustomTextView(text: "Стартап-студия 'Структура'")
                Spacer()
                    .frame(height: 16)
                CustomTextView(text: "Стартап-студия 'Структура'")
                Spacer()
                    .frame(height: 16)
                CustomTextView(text: "Стартап-студия 'Структура'")
                Spacer()
                    .frame(height: 16)
                CustomTextView(text: "Стартап-студия 'Структура'")
                Spacer()
                    .frame(height: 16)
                CustomTextView(text: "Стартап-студия 'Структура'")
                Spacer()
                    .frame(height: 16)
                CustomTextView(text: "Стартап-студия 'Структура'")
                Spacer()
                    .frame(height: 16)
                CustomTextView(text: "Стартап-студия 'Структура'")
                Spacer()
                    .frame(height: 16)
                CustomTextView(text: "Стартап-студия 'Структура'")
                Spacer()
                    .frame(height: 16)
                CustomTextView(text: "Стартап-студия 'Структура'")
                Spacer()
                    .frame(height: 16)
                CustomTextView(text: "Стартап-студия 'Структура'")
                Spacer()
                    .frame(height: 16)
            }
            .padding(
                [.horizontal],
                20
            )
        }
        .ignoresSafeArea()
        .redacted(
            reason: .placeholder
        )
        .shimmering()
    }
}
