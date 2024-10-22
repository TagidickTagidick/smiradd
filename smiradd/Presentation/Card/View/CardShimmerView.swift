import SwiftUI
import Shimmer

struct CardShimmerView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        VStack (alignment: .leading) {
            Image("avatar")
                .background(.gray)
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
        .redacted(
            reason: .placeholder
        )
        .shimmering()
    }
}
