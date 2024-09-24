import SwiftUI

struct TemplatesPageView: View {
    @EnvironmentObject var viewModel: CardViewModel
    
    @EnvironmentObject var commonViewModel: CommonViewModel
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var currentIndex: Int = -1
    
    var body: some View {
        ZStack (alignment: .bottom) {
            ScrollView {
                VStack (alignment: .leading) {
                    CustomAppBarView(
                        title: "Шаблоны",
                        action: {
                            self.viewModel.closeTemplates(id: "")
                        }
                    )
                    Spacer()
                        .frame(height: 16)
                    Text("Выберите шаблон для своей визитки\nТак вашу визитку будут видеть другие люди")
                        .multilineTextAlignment(.center)
                        .font(
                            .custom(
                                "OpenSans-Medium",
                                size: 13
                            )
                        )
                        .foregroundStyle(textAdditional)
                    Spacer()
                        .frame(height: 16)
                    ForEach(
                        Array(
                            self.commonViewModel.templates.enumerated()),
                        id: \.offset
                    ) {
                        index,
                        templatesModel in
                        VStack {
                            ZStack {
                                MyCardView(
                                    cardModel: CardModel.makeMock(
                                        templateId: templatesModel.id
                                    ),
                                    isMyCard: true
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            Color(
                                            red: 0.408,
                                            green: 0.784,
                                            blue: 0.58
                                        ),
                                            lineWidth: currentIndex == index ? 4 : 0
                                        )
                                    )
                                .onTapGesture {
                                    currentIndex = index
                                }
                                if currentIndex == index {
                                    ZStack {
                                        Circle()
                                            .fill(Color(
                                                red: 0.408,
                                                green: 0.784,
                                                blue: 0.58
                                            ))
                                            .frame(
                                                width: 48,
                                                height: 48
                                            )
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                            Spacer().frame(height: 16)
                        }
                    }
                    Spacer()
                        .frame(height: 74)
                }
                .padding(
                    [.horizontal],
                    20
                )
            }
            CustomButtonView(
                text: "Сохранить",
                color: Color(
                red: 0.408,
                green: 0.784,
                blue: 0.58
            ))
            .offset(
                y: currentIndex != -1
                ? -74
                : 200
            )
                .animation(.spring())
                .transition(.move(edge: .bottom))
                .onTapGesture {
                    self.viewModel.closeTemplates(
                        id: self.commonViewModel.templates[currentIndex].id
                    )
                }
            CustomBottomNavigationBarView()
        }
        .navigationBarHidden(true)
        .background(.white)
    }
}

extension Animation {
    static func ripple() -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
    }
}
