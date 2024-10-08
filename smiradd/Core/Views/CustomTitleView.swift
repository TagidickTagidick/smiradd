import SwiftUI

struct CustomTitleView: View {
    let text: String
    
    var body: some View {
        Text(self.text)
            .font(
                .custom(
                    "OpenSans-SemiBold",
                    size: 24
                )
            )
            .foregroundStyle(textDefault)
    }
}
