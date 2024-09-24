import SwiftUI

struct CustomTextView: View {
    let text: String
    var isRequired: Bool = false
    
    var body: some View {
        HStack {
            Text(self.text)
                .font(
                    .custom(
                        "OpenSans-Medium",
                        size: 14
                    )
                )
                .foregroundStyle(textAdditional)
            Text(self.isRequired ? "*" : "")
                .font(
                    .custom(
                        "OpenSans-Medium",
                        size: 14
                    )
                )
                .foregroundStyle(
                    Color(
                        red: 0.973,
                        green: 0.404,
                        blue: 0.4
                    )
                )
        }
    }
}
