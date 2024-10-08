import SwiftUI
import Shimmer
import CodeScanner

struct FavoritesAppBarView: View {
    let onTapFilters: (() -> ())
    let onTapScan: (() -> ())
    
    @Binding var isShowingScanner: Bool
    let onScan: (Result<ScanResult, ScanError>) -> Void
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    var body: some View {
        HStack (alignment: .center) {
            CustomTitleView(
                text: "Избранное"
            )
            Spacer()
            if self.commonViewModel.favoritesSpecificities.isEmpty {
                Image("filter")
                    .onTapGesture {
                        self.onTapFilters()
                    }
            }
            else {
                HStack {
                    Image("filter")
                        .renderingMode(.template)
                        .foregroundColor(.white)
                    Text(String(self.commonViewModel.favoritesSpecificities.count))
                        .font(
                            .custom(
                                "OpenSans-SemiBold",
                                size: 16
                            )
                        )
                        .foregroundStyle(.white)
                }
                .padding(
                    [.horizontal],
                    12
                )
                .padding(
                    [.vertical],
                    4
                )
                .background(textDefault)
                .cornerRadius(16)
                .onTapGesture {
                    self.onTapFilters()
                }
            }
            Spacer()
                .frame(width: 24)
            Image("scan")
                .onTapGesture {
                    self.onTapScan()
                }
                .sheet(isPresented: self.$isShowingScanner) {
                    CodeScannerView(
                        codeTypes: [.qr],
                        simulatedData: "Paul Hudson\npaul@hackingwithswift.com",
                        completion: self.onScan
                    )
                }
        }
        .padding(
            [.horizontal],
            20
        )
        .padding(
            [.bottom],
            20
        )
        .background(accent50)
    }
}
