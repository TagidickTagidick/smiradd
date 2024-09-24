import SwiftUI

struct TeamTemplateView: View {
    let teamMainModel: TeamMainModel
    
    var body: some View {
        ZStack {
            MyTeamCardView(
                teamMainModel: teamMainModel
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
//        .frame(
//            width: UIScreen.main.bounds.width - 40,
//            height: 228
//        )
    }
}
