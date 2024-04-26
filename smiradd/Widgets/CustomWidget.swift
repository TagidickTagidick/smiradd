import SwiftUI

struct CustomWidget: View {
    @Binding var isLoading: Bool
    
    var isNoInternet: Bool
    var onTap: () -> Void
    
    var isCard: Bool

    var image: String
    var title: String
    var description: String
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
            }
            else {
                VStack {
                    Image("match_not_found")
                    Spacer()
                        .frame(height: 14)
                    Text("Рядом нет активных форумов")
                        .font(
                            .custom(
                                "OpenSans-Medium",
                                size: 16
                            )
                        )
                        .foregroundStyle(textDefault)
                    Spacer()
                        .frame(height: 14)
                    Text("Посетите форум, чтобы увидеть здесь визитки близких по духу людей")
                        .multilineTextAlignment(.center)
                        .font(
                            .custom(
                                "OpenSans-Regular",
                                size: 14
                            )
                        )
                        .foregroundStyle(Color(
                            red: 0.6,
                            green: 0.6,
                            blue: 0.6
                        ))
                    
                    if isNoInternet {
                        VStack {
                            Spacer()
                                .frame(height: 36)
                            ZStack {
                                Spacer()
                                    .frame(
                                        maxWidth: .infinity,
                                        maxHeight: 56
                                    )
                                    .background(.white)
                                    .cornerRadius(28)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 28)
                                            .stroke(textDefault)
                                    )
                                Text("Повторить")
                                    .font(
                                        .custom(
                                            "OpenSans-SemiBold",
                                            size: 16
                                        )
                                    )
                                    .foregroundStyle(textDefault)
                            }
                            .onTapGesture {
                                self.onTap()
                            }
                        }
                    }
                }
                .padding(
                    [.horizontal],
                    44
                )
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(isCard ? .white : accent50)
        .cornerRadius(16)
        .shadow(
            color: isCard ? Color(
                red: 0.125,
                green: 0.173,
                blue: 0.275,
                opacity: 0.08
            ) : accent50,
            radius: isCard ? 16 : 0,
            y: isCard ? 4 : 0
        )
    }
}
