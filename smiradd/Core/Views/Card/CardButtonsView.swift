import SwiftUI

struct CardButtonsView: View {
    var cardId: String
    let onDislike: (() -> ())
    let onLike: (() -> ())
    
    var body: some View {
        HStack {
            Text("На мероприятии")
                .font(
                    .custom(
                        "OpenSans-Regular",
                        size: 15
                    )
                )
                .foregroundStyle(textDefault)
            Spacer()
            ZStack {
                Circle()
                    .fill(Color(
                        red: 0.973,
                        green: 0.404,
                        blue: 0.4
                    ))
                    .frame(
                        width: 48,
                        height: 48
                    )
                Image(systemName: "xmark")
                    .foregroundColor(.white)
            }
            .onTapGesture {
                self.onDislike()
            }
            ZStack {
                Circle()
                    .fill(Color(
                        red: 0.408,
                        green: 0.784,
                        blue: 0.58
                    ))
                    .frame(
                        width: 48,
                        height: 48
                    )
                Image(systemName: "heart")
                    .foregroundColor(.white)
            }
            .onTapGesture {
                self.onLike()
            }
        }
    }
}
