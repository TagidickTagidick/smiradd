import SwiftUI

struct SaveButton: View {
    var canSave: Bool
    
    var body: some View {
        ZStack {
            Text("Сохранить")
                .font(
                    .custom(
                        "OpenSans-SemiBold",
                        size: 16
                    )
                )
                .foregroundStyle(.white)
        }
        .frame(
            width: UIScreen.main.bounds.width - 40,
            height: 56
        )
        .background(
            canSave
            ? Color(
            red: 0.408,
            green: 0.784,
            blue: 0.58
        ) : Color(
            red: 0.867,
            green: 0.867,
            blue: 0.867
        )
        )
        .cornerRadius(28)
    }
}
