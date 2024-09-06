import SwiftUI

struct CardServicesTileView: View {
    @EnvironmentObject var viewModel: CardViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Spacer()
                    .frame(width: 20)
                NavigationStack {
                    CardPlusButtonView()
                        .navigationDestination(isPresented: $viewModel.servicesOpened) {
                        ServicePageView()
                            .environmentObject(self.viewModel)
                    }
                        .onTapGesture {
                            self.viewModel.openServices(serviceIndex: -1)
                        }
                }
                Spacer()
                    .frame(width: 12)
                ForEach(
                    Array(self.viewModel.services.enumerated()),
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
                        self.viewModel.openServices(serviceIndex: index)
                    }
                }
            }
        }
    }
}
