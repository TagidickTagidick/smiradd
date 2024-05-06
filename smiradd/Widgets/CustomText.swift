import SwiftUI

struct CustomText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(
                .custom(
                    "OpenSans-Medium",
                    size: 14
                )
            )
            .foregroundStyle(textAdditional)
    }
}
