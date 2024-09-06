import SwiftUI

struct CustomIcon: View {
    var icon: String
    var black: Bool
    
    var body: some View {
        ZStack {
            Image(icon)
                .renderingMode(.template)
                .foregroundColor(black ? .white : textDefault)
        }
        .frame(
            width: 48,
            height: 48
        )
        .background(black ? textDefault : .white)
        .clipShape(Circle())
    }
}
