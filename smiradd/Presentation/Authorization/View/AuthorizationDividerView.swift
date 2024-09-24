import SwiftUI

struct AuthorizationDividerView: View {
    var body: some View {
        HStack {
            Spacer()
                .frame(height: 1)
                .background(textDefault)
            Spacer()
                .frame(width: 16)
            Text("или")
                .font(
                    .custom(
                        "OpenSans-SemiBold",
                        size: 15
                    )
                )
                .foregroundStyle(textDefault)
            Spacer()
                .frame(width: 16)
            Spacer()
                .frame(height: 1)
                .background(textDefault)
        }
    }
}
