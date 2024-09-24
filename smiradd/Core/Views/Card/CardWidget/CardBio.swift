import SwiftUI

struct CardBio: View {
    let title: String
    var bio: String
    
    var body: some View {
        Spacer()
            .frame(height: 12)
        CustomTextView(text: self.title)
        Spacer()
            .frame(height: 8)
        ExpandableText(
            self.bio,
            lineLimit: 5
        )
    }
}
