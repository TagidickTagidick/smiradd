import SwiftUI

struct BackButtonView: View {
    @EnvironmentObject private var navigationService: NavigationService
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.4))
                .frame(
                    width: 48,
                    height: 48
                )
            Image(
                systemName: "arrow.left"
            )
                .foregroundColor(textDefault)
        }
        .onTapGesture {
            self.navigationService.navigateBack()
        }
    }
}
