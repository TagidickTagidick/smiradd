import SwiftUI

struct CustomNotificationView: View {
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    var body: some View {
        HStack {
            Image(systemName: self.commonViewModel.isErrorAlert ? "xmark" : "checkmark")
                .foregroundColor(.white)
            Spacer()
                .frame(width: 4)
            Text(self.commonViewModel.alertText)
                .font(
                    .custom(
                        "OpenSans-Medium",
                        size: 16
                    )
                )
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(
            [.horizontal],
            16
        )
        .padding(
            [.vertical],
            12
        )
        .frame(
            width: UIScreen.main.bounds.width - 40,
            height: 72
        )
        .background(
            self.commonViewModel.isErrorAlert ? Color(
                red: 0.898,
                green: 0.271,
                blue: 0.267
            ) : Color(
                red: 0.408,
                green: 0.784,
                blue: 0.58,
                opacity: 0.898
            )
        )
        .cornerRadius(8)
    }
}
