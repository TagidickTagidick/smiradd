import SwiftUI

struct WrappedLayoutView: View {
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    let onTap: (() -> ())
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(
                self.commonViewModel.networkingSpecificities,
                id: \.self
            ) {
                platform in
                self.item(for: platform)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if platform == self.commonViewModel.networkingSpecificities.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if platform == self.commonViewModel.networkingSpecificities.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }

    func item(for text: String) -> some View {
        FilterButtonView(
            isChosen: false,
            text: text
        )
        .onTapGesture {
            self.onTap()
        }
    }
}
