import SwiftUI

struct CustomAppBar: View {
    @EnvironmentObject var router: NavigationService
    
    var title: String
    var action: (() -> ())?
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.left")
                .foregroundColor(buttonClick)
                .onTapGesture {
                    if (action == nil) {
                        router.navigateBack()
                    }
                    else {
                        action!()
                    }
                }
            Spacer()
                .frame(width: 24)
            Text(title)
                .font(
                    .custom(
                        "OpenSans-SemiBold",
                        size: 24
                    )
                )
                .foregroundStyle(textDefault)
            Spacer()
        }
        .padding(
            [.vertical],
            8
        )
    }
}
