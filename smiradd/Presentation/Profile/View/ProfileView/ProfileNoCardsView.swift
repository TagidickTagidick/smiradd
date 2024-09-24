import SwiftUI

struct ProfileNoCardsView: View {
    var title: String
    var description: String
    var onTap: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(
                    style: StrokeStyle(
                        lineWidth: 4,
                        dash: [10]
                    )
                )
                .frame(
                    width: UIScreen.main.bounds.size.width - 40,
                    height: 200
                )
            VStack {
                Spacer()
                Text(title)
                    .font(
                        .custom(
                            "OpenSans-Medium",
                            size: 16
                        )
                    )
                    .foregroundStyle(textDefault)
                Spacer()
                    .frame(height: 8)
                Text(description)
                    .font(
                        .custom(
                            "OpenSans-Regular",
                            size: 14
                        )
                    )
                    .foregroundStyle(textAdditional)
                    .multilineTextAlignment(.center)
                Spacer()
                    .frame(height: 16)
                CustomWhiteButtonView(text: "Создать визитку")
                    .frame(width: 193)
                    .onTapGesture {
                        self.onTap()
                    }
                Spacer()
            }
        }
        .padding(
            [.horizontal],
            20
        )
    }
}
