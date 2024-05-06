import SwiftUI

struct NetworkingCard: View {
    var image: String
    var title: String
    var description: String
    
    var body: some View {
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
            }
            .padding(
                [.horizontal],
                44
            )
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(.white)
        .cornerRadius(16)
    }
}
