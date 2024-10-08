import SwiftUI

struct NetworkingAppBarView: View {
    let onTapExit: (() -> ())
    let onTapFilter: (() -> ())
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
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
            CustomTitleView(
                text: "Нетворкинг"
            )
            Spacer()
            ZStack(alignment: .topTrailing) {
                Image("filter_networking")
                    .frame(
                        width: 24,
                        height: 24
                    )
                    .offset(
                        x: -6,
                        y: 6
                    )
                if !self.commonViewModel.networkingSpecificities.isEmpty {
                    Circle()
                        .frame(
                            width: 12,
                            height: 12
                        )
                        .foregroundColor(textAccent)
                        .offset(
                            x: -3,
                            y: 3
                        )
                }
            }
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
