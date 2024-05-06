import SwiftUI

struct CustomAppBar: View {
    @EnvironmentObject var router: Router
    
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.left")
                .foregroundColor(buttonClick)
                .onTapGesture {
                    router.navigateBack()
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
