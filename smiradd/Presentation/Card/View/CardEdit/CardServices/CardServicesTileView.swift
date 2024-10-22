import SwiftUI

struct CardServicesTileView: View {
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @EnvironmentObject var viewModel: CardViewModel
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 20)
            CustomTextView(
                text: "Услуги"
            )
            Spacer()
        }
        Spacer()
            .frame(height: 12)
        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {
            HStack {
                Spacer()
                    .frame(width: 20)
                CardPlusButtonView(
                    height: 192
                )
                    .onTapGesture {
                        self.viewModel.openServices(index: -1)
                    }
                Spacer()
                    .frame(width: 12)
                ForEach(
                    Array(self.commonViewModel.services.enumerated()),
                    id: \.offset
                ) {
                    index, service in
                    ZStack {
                        CardServiceView(service: service)
                        HStack {
                            Image("edit")
                            Spacer()
                                .frame(width: 10)
                            Text("Изменить")
                                .font(
                                    .custom(
                                        "OpenSans-SemiBold",
                                        size: 16
                                    )
                                )
                                .foregroundStyle(textDefault)
                        }
                        .padding(
                            [.vertical],
                            9
                        )
                        .padding(
                            [.horizontal],
                            20
                        )
                        .background(.white.opacity(0.6))
                        .cornerRadius(24)
                    }
                    .onTapGesture {
                        self.viewModel.openServices(index: index)
                    }
                }
            }
        }
    }
}
