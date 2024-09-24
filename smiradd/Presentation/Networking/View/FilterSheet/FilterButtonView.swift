import SwiftUI

struct FilterButtonView: View {
    let isChosen: Bool
    let text: String
    
    var body: some View {
        ZStack {
            Text(self.text)
                .font(
                    .custom(
                        "OpenSans-Medium",
                        size: 16
                    )
                )
                .foregroundStyle(
                    self.isChosen ? .white : accent500
                )
        }
        .padding(
            [.horizontal],
            12
        )
        .padding(
            [.vertical],
            8
        )
        .background(self.isChosen ? textAccent : accent100)
        .cornerRadius(24)
    }
}
