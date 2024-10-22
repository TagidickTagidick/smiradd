import SwiftUI

struct CirculationCreationView: View {
    @State private var pageType: PageType = .matchNotFound
    
    @State private var problem: String = ""
    @FocusState private var problemIsFocused: Bool
    
    @State private var ticketModel: TicketModel?
    
    var action: ((String) -> ())
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            if pageType == .loading {
                ProgressView()
            }
            else {
                VStack {
                    Spacer()
                        .frame(height: 8)
                    Rectangle()
                        .fill(accent100)
                        .cornerRadius(3)
                        .frame(
                         width: 56,
                         height: 6
                        )
                    Spacer()
                        .frame(height: 18)
                    Text("Создание обращения")
                        .font(
                            .custom(
                                "OpenSans-SemiBold",
                                size: 20
                            )
                        )
                        .foregroundStyle(textDefault)
                    Spacer()
                        .frame(height: 16)
                    Text("Напишите нам, и мы обязательно вам поможем")
                        .font(
                            .custom(
                                "OpenSans-Regular",
                                size: 14
                            )
                        )
                        .foregroundStyle(textAdditional)
                    Spacer()
                        .frame(height: 16)
                    CustomTextFieldView(
                     value: $problem,
                     hintText: "Опишите проблему",
                     focused: $problemIsFocused,
                     height: 169,
                        limit: 300,
                     isLongText: true
                    )
                    Spacer()
                        .frame(height: 20)
                    CustomButtonView(
                        text: "Отправить",
                        color: textDefault
                    )
                        .onTapGesture {
                            self.action(problem)
                        }
                    Spacer()
                        .frame(height: 20)
                }
                .padding(
                 [.horizontal],
                 20
                )
            }
        }
        .presentationCornerRadius(16)
        .presentationDetents([.height(393)])
         .onAppear {
             problemIsFocused = true
         }
    }
}
