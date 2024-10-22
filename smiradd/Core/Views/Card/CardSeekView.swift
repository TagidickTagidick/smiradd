import SwiftUI

struct CardSeekView: View {
    var isRight: Bool = false
    var title: String
    var text: String
    
    var body: some View {
        VStack (
            alignment: self.isRight ? .trailing : .leading
        ) {
            CustomTextView(
                text: self.title
            )
            Spacer()
                .frame(height: 8)
            ZStack {
                Text(
                    self.text
                )
                .font(
                    .custom(
                        "OpenSans-Regular",
                        size: 14
                    )
                )
                .foregroundStyle(textDefault)
            }
            .padding(
                [.all],
                10
            )
            .background(
                Color(
                    red: 0.961,
                    green: 0.961,
                    blue: 0.961
                )
            )
            .cornerRadius(16)
        }
    }
}
