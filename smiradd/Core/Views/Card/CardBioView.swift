import SwiftUI
import ExpandableText

struct CardBioView: View {
    let title: String
    let bio: String
    let showButton: Bool
    
    var body: some View {
        Spacer()
            .frame(height: 12)
        CustomTextView(text: self.title)
        Spacer()
            .frame(height: 8)
        ReadMore(
            lineLimit: 3,
            showButton: self.showButton
        ) {
            Text(self.bio)
                .font(
                    .custom(
                        "OpenSans-Regular",
                        size: 14
                    )
                )
                .foregroundColor(textDefault)
        }
//        ExpandableText(self.bio)
//            .font(
//                .custom(
//                    "OpenSans-Regular",
//                    size: 14
//                )
//            )
//            .foregroundColor(textDefault)
//            .lineLimit(3)
//            .moreButtonText("Показать ещё")
//            .moreButtonFont(
//                .custom(
//                    "OpenSans-SemiBold",
//                    size: 14
//                )
//            )
//            .moreButtonColor(accent400)
    }
}

struct ReadMore<Content: View>: View {
    let lineLimit: Int
    let showButton: Bool

    @ViewBuilder var content: Content

    @State private var isExpanded: Bool = false

    var body: some View {
        ReadMoreLayout {
            ViewThatFits(in: .vertical) {
                if !isExpanded {
                    fullView
                }

                shortView
            }
        }
    }
    
    var fullView: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
    }

    var shortView: some View {
        VStack(alignment: .leading) {
            if self.showButton {
                ZStack {
                    content
                        .lineLimit(isExpanded ? nil : max(1, lineLimit))
                        .contentTransition(.opacity)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
                .clipped()
            }
            else {
                ZStack {
                    content
                        .lineLimit(isExpanded ? nil : max(1, lineLimit))
                        .contentTransition(.opacity)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .clipped()
            }
            if self.showButton {
                Button {
                    withAnimation {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text(isExpanded ? "Скрыть" : "Показать ещё")
                            .font(
                                .custom(
                                    "OpenSans-SemiBold",
                                    size: 14
                                )
                            )
                            .foregroundColor(accent400)
                    }
                }
                .backportGeometryGroup()
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder func withSymbolTransition(@ViewBuilder image: () -> some View) -> some View {
        if #available(iOS 17.0, *) {
            image()
                .contentTransition(.symbolEffect(.replace.wholeSymbol.offUp))
        } else {
            image()
        }
    }
}

private struct ReadMoreLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        guard let view = subviews.first else {
            return proposal.replacingUnspecifiedDimensions()
        }

        let expanded = view.sizeThatFits(
            .init(
                width: proposal.replacingUnspecifiedDimensions().width,
                height: nil
            )
        )
        let collapsed = view.sizeThatFits(
            .init(
                width: proposal.replacingUnspecifiedDimensions().width,
                height: .zero
            )
        )

        if expanded.height <= collapsed.height {
            return expanded
        } else {
            return collapsed
        }
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
        let size = sizeThatFits(proposal: proposal, subviews: subviews, cache: &cache)
        subviews.first?.place(
            at: .init(x: bounds.midX, y: bounds.midY),
            anchor: .center,
            proposal: .init(width: size.width, height: size.height)
        )
    }
}

extension View {
    @ViewBuilder public func backportGeometryGroup() -> some View {
        if #available(iOS 17, *) {
            geometryGroup()
        } else {
            transformEffect(.identity)
        }
    }
}
