import SwiftUI

struct CustomIconView: View {
    var icon: String
    var black: Bool
    
    var body: some View {
        ZStack {
            Image(icon)
                .renderingMode(.template)
                .foregroundColor(black ? textDefault : .white)
        }
        .frame(
            width: 48,
            height: 48
        )
        .background(black ? .white : textDefault)
        .clipShape(Circle())
    }
}
