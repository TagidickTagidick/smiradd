import SwiftUI

struct DeleteView: View {
    var text: String
    
    var body: some View {
        Spacer()
            .frame(height: 32)
        HStack {
            Image("delete")
            Spacer()
                .frame(width: 12)
            Text("Удалить \(text)")
                .font(
                    .custom(
                        "OpenSans-SemiBold",
                        size: 16
                    )
                )
                .foregroundStyle(
                    Color(
                    red: 0.898,
                    green: 0.271,
                    blue: 0.267
                )
                )
        }
    }
}
