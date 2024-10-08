import SwiftUI

struct CardTemplateView: View {
    let cardModel: CardModel
    
    var body: some View {
        ZStack {
            MyCardView(
                cardModel: cardModel,
                isMyCard: true
            )
            CardButtonView(
                image: "edit_template",
                text: "Изменить логотип"
            )
            .frame(
                minWidth: UIScreen.main.bounds.width - 152,
                minHeight: 48
            )
            .background(accent50)
            .cornerRadius(24)
        }
        .frame(
            minWidth: UIScreen.main.bounds.width - 40,
            minHeight: 228
        )
    }
}
