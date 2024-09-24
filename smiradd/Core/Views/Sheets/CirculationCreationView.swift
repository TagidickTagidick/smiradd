import SwiftUI

struct CirculationCreationView: View {
    @Binding var isHelp: Bool
    
    @State private var pageType: PageType = .matchNotFound
    
    @State private var problem: String = ""
    @FocusState private var problemIsFocused: Bool
    
    @State private var ticketModel: TicketModel?
    
    @EnvironmentObject private var viewModel: SettingsViewModel
    
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
                            self.viewModel.createCirculation(problem: problem)
//                            let body: [String: String] = ["main_text": problem]
//                            let finalBody = try! JSONSerialization.data(withJSONObject: body)
//                            makeRequest(path: "tickets", method: .post, body: finalBody) { (result: Result<TicketModel, Error>) in
//                                switch result {
//                                case .success(let ticketModel):
//                                    self.ticketModel = ticketModel
//                                    self.pageType = .matchNotFound
//                                    self.isHelp = false
//                                case .failure(let error):
//                                    if error.localizedDescription == "The Internet connection appears to be offline." {
//                                        self.pageType = .noResultsFound
//                                    }
//                                    else {
//                                        self.pageType = .somethingWentWrong
//                                    }
//                                    self.isHelp = false
//                                    print(error.localizedDescription)
//                                }
//                            }
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
