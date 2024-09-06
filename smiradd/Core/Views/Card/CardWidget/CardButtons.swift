import SwiftUI

struct CardButtons: View {
    var cardId: String
    
    var body: some View {
        HStack {
            Text("100 м отсюда")
                .font(
                    .custom(
                        "OpenSans-Regular",
                        size: 15
                    )
                )
                .foregroundStyle(textDefault)
            Spacer()
            ZStack {
                Circle()
                    .fill(Color(
                        red: 0.973,
                        green: 0.404,
                        blue: 0.4
                    ))
                    .frame(
                        width: 48,
                        height: 48
                    )
                Image(systemName: "xmark")
                    .foregroundColor(.white)
            }
            .onTapGesture {
//                makeRequest(
//                    path: "cards/\(cardModel.id)/favorites",
//                    method: .delete
//                ) { (result: Result<DetailsModel, Error>) in
//                    DispatchQueue.main.async {
//                        switch result {
//                        case .success(_):
//                            withAnimation {
//                                cards.swipe(direction: .left, completion: nil)
//                            }
//                        case .failure(_):
//                            print("failure")
//                        }
//                    }
//                }
            }
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
                Image(systemName: "heart")
                    .foregroundColor(.white)
            }
            .onTapGesture {
//                makeRequest(
//                    path: "cards/\(cardModel.id)/favorites",
//                    method: .post
//                ) { (result: Result<DetailsModel, Error>) in
//                    DispatchQueue.main.async {
//                        switch result {
//                        case .success(_):
//                            withAnimation {
//                                cards.swipe(direction: .right, completion: nil)
//                            }
//                        case .failure(_):
//                            print("failure")
//                        }
//                    }
//                }
            }
        }
    }
}
