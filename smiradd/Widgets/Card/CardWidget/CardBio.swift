import SwiftUI

struct CardBio: View {
    var bio: String
    
    var body: some View {
        Spacer()
            .frame(height: 12)
        CustomText(text: "О себе")
        Spacer()
            .frame(height: 8)
        ExpandableText(
            bio,
            lineLimit: 5
        )
    }
}
