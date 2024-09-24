import SwiftUI

struct NetworkingAppBarView: View {
    let onTapExit: (() -> ())
    let onTapFilter: (() -> ())
    
    var body: some View {
        HStack {
            Spacer()
                .frame(
                    width: 20
                )
            Image("exit_networking")
                .frame(
                    width: 36,
                    height: 36
                )
                .onTapGesture {
                    self.onTapExit()
                }
            Spacer()
            Text("Нетворкинг")
            .font(
                .custom(
                    "OpenSans-SemiBold",
                    size: 24
                )
            )
            .foregroundStyle(textDefault)
            Spacer()
            Image("filter_networking")
                .frame(
                    width: 36,
                    height: 36
                )
                .onTapGesture {
                    self.onTapFilter()
                }
            Spacer()
                .frame(
                    width: 20
                )
        }
        .frame(
            height: 58
        )
    }
}
