import SwiftUI

struct ProfileTileView: View {
    let text: String
    let onTap: () -> Void
    let showButton: Bool
    
    var body: some View {
        HStack {
            Text(text)
                .font(
                    .custom(
                        "OpenSans-SemiBold",
                        size: 24
                    )
                )
                .foregroundStyle(textDefault)
            Spacer()
            if self.showButton {
                Image(systemName: "plus")
                    .frame(
                        width: 36,
                        height: 36
                    )
                    .foregroundStyle(textDefault)
                    .onTapGesture {
                        onTap()
                    }
            }
        }
        .padding(
            [.horizontal],
            20
        )
    }
}
