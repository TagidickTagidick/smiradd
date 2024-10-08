import SwiftUI

struct FilterTileView: View {
    var isFavorite: Bool
    let name: String
    
    var body: some View {
        HStack {
            Text(self.name)
                .font(
                    .custom(
                        self.isFavorite
                        ? "OpenSans-SemiBold"
                        : "OpenSans-Regular",
                        size: 16
                    )
                )
                .foregroundStyle(textDefault)
            Spacer()
            ZStack {
                if self.isFavorite {
                    Image(systemName: "checkmark")
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .frame(
                            width: 10,
                            height: 8
                        )
                }
            }
            .frame(
                width: 20,
                height: 20
            )
            .background(
                self.isFavorite
                ? Color(
                    red: 0.408,
                    green: 0.784,
                    blue: 0.58
                )
                : .white
            )
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        accent100,
                        lineWidth: 1
                    )
            )
        }
        .padding([.vertical], 12)
        .background(.white)
    }
}
