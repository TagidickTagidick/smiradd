import SwiftUI

struct SplashScreen: View {
    var body: some View {
        Image("logo")
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .background(accent200)
            .navigationBarBackButtonHidden(true)
    }
}
