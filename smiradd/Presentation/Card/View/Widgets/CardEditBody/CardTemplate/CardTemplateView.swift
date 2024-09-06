import SwiftUI

struct CardTemplateView: View {
    let cardModel: CardModel
    
    var body: some View {
        ZStack {
            MyCard(cardModel: cardModel)
            CardButtonView(
                image: "edit_template",
                text: "Изменить логотип"
            )
            .background(accent50)
            .frame(
                minWidth: UIScreen.main.bounds.width - 152,
                minHeight: 48
            )
        }
        .frame(
            minWidth: UIScreen.main.bounds.width - 40,
            minHeight: 228
        )
//        .onTapGesture {
//            //router.navigate(to: .templatesScreen)
//        }
    }
}
