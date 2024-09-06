import SwiftUI

struct CardPlusButtonView: View {
    var body: some View {
        Image(systemName: "plus")
            .frame(
                width: 36,
                height: 36
            )
            .foregroundStyle(textAdditional)
            .frame(
                width: 160,
                height: 192
            )
            .background(accent50)
            .cornerRadius(16)
    }
}
