import SwiftUI

struct CardTemplate: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var cardSettings: CardSettings
    
    var body: some View {
        ZStack {
            MyCard(cardModel: cardSettings.cardModel)
            HStack {
                Image("edit_template")
                Spacer()
                    .frame(width: 8)
                Text("Изменить логотип")
                    .font(
                        .custom(
                            "OpenSans-SemiBold",
                            size: 18
                        )
                    )
                    .foregroundStyle(textDefault)
            }
            .frame(
                minWidth: UIScreen.main.bounds.width - 152,
                minHeight: 48
            )
            .background(accent50)
            .cornerRadius(24)
        }
        .onTapGesture {
            router.navigate(to: .templatesScreen)
        }
    }
}
