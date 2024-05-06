import SwiftUI

struct TutorialScreen: View {
    @Binding var isTutorial: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Image("tap")
                .frame(
                    width: 149,
                    height: 168
                )
            HStack {
                Spacer()
                    .frame(width: 20)
                Image("left")
                    .frame(
                        width: 146,
                        height: 168
                    )
                Spacer()
                Image("right")
                    .frame(
                        width: 153,
                        height: 168
                    )
                Spacer()
                    .frame(width: 20)
            }
            Spacer()
        }
        .background(.black.opacity(0.6))
        .frame(
            minWidth: UIScreen.main.bounds.width,
            minHeight: UIScreen.main.bounds.height
        )
        .onTapGesture {
            UserDefaults.standard.set(
                true,
                forKey: "first_time"
            )
            self.isTutorial = false
            print(isTutorial)
        }
    }
}
