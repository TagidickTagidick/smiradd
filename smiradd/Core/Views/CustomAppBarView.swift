import SwiftUI

struct CustomAppBarView: View {
    @EnvironmentObject var navigationService: NavigationService
    
    let title: String
    var action: (() -> ())? = nil
    var onClear: (() -> ())? = nil
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.left")
                .foregroundColor(buttonClick)
                .onTapGesture {
                    if (action == nil) {
                        self.navigationService.navigateBack()
                    }
                    else {
                        self.action!()
                    }
                }
            Spacer()
                .frame(width: 24)
            Text(self.title)
                .font(
                    .custom(
                        "OpenSans-SemiBold",
                        size: 24
                    )
                )
                .foregroundStyle(textDefault)
            Spacer()
            if self.onClear != nil {
                Text("Очистить")
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
                    .onTapGesture {
                        self.onClear!()
                    }
            }
        }
        .padding(
            [.vertical],
            8
        )
    }
}
