import SwiftUI

struct NetworkingScreen: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading) {
                Text("Нетворкинг")
                    .font(
                        .custom(
                            "OpenSans-SemiBold",
                            size: 24
                        )
                    )
                    .foregroundStyle(textDefault)
                Spacer()
                    .frame(height: 20)
                ZStack {
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
                    }
                    .padding(
                        [.horizontal],
                        44
                    )
        //            .background(Color(
        //                red: 0.125,
        //                green: 0.173,
        //                blue: 0.275,
        //                opacity: 0.08
        //            ))
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
                .background(.white)
                .cornerRadius(16)
                Spacer()
                    .frame(height: 78)
            }
            .padding(
                [.horizontal],
                20
            )
            .shadow(
                color: Color(
                    red: 0.125,
                    green: 0.173,
                    blue: 0.275,
                    opacity: 0.08
                ),
                radius: 16,
                y: 4
            )
        }
        .background(accent50)
        .ignoresSafeArea()
    }
}
