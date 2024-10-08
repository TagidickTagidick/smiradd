import SwiftUI
import Shimmer

struct FavoritesLoadingView: View {
    var body: some View {
        MyCardView(
            cardModel: CardModel.mock,
            isMyCard: false
        )
        .redacted(
            reason: .placeholder
        )
        .shimmering()
        Spacer()
            .frame(height: 16)
        MyCardView(
            cardModel: CardModel.mock,
            isMyCard: false
        )
        .redacted(
            reason: .placeholder
        )
        .shimmering()
        Spacer()
            .frame(height: 16)
        MyCardView(
            cardModel: CardModel.mock,
            isMyCard: false
        )
        .redacted(
            reason: .placeholder
        )
        .shimmering()
        Spacer()
            .frame(height: 16)
    }
}
