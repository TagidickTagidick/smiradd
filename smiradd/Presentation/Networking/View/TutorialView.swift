import SwiftUI

struct TutorialView: View {
    @Binding var isTutorial: Bool
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image("tap_icon")
                    .frame(
                        width: 160,
                        height: 156
                    )
            }
            Spacer()
            Image("tap_card")
                .frame(
                    width: 149,
                    height: 168
                )
            HStack {
                Spacer()
                    .frame(width: 20)
                Image("swipe_left")
                    .frame(
                        width: 146,
                        height: 168
                    )
                Spacer()
                Image("swipe_right")
                    .frame(
                        width: 153,
                        height: 168
                    )
                Spacer()
                    .frame(width: 20)
            }
            Spacer()
            Spacer()
            Spacer()
        }
        .background(.black.opacity(0.6))
        .frame(
            width: UIScreen.main.bounds.size.width,
            height: UIScreen.main.bounds.size.height - 58 - safeAreaInsets.bottom
        )
        .onTapGesture {
            UserDefaults.standard.set(
                true,
                forKey: "first_time"
            )
            self.isTutorial = false
        }
    }
}
