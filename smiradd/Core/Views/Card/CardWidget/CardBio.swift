import SwiftUI
import ExpandableText

struct CardBio: View {
    let title: String
    var bio: String
    
    var body: some View {
        Spacer()
            .frame(height: 12)
        CustomTextView(text: self.title)
        Spacer()
            .frame(height: 8)
        ExpandableText(self.bio)
            .font(
                .custom(
                    "OpenSans-Regular",
                    size: 14
                )
            )
            .foregroundColor(textDefault)
            .lineLimit(5)
            .moreButtonText("Показать ещё")
            .moreButtonFont(
                .custom(
                    "OpenSans-SemiBold",
                    size: 14
                )
            )
            .moreButtonColor(accent400)
    }
}
