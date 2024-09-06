import SwiftUI

struct ProfileTileView: View {
    var text: String
    var onTap: () -> Void
    
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
}
