import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct CardLogo: View {
    var cardModel: CardModel
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text(cardModel.job_title)
                    .font(
                        .custom(
                            "OpenSans-SemiBold",
                            size: 20
                        )
                    )
                    .foregroundStyle(textDefault)
                Spacer()
                    .frame(height: 8)
                Text(cardModel.name)
                    .font(
                        .custom(
                            "OpenSans-Medium",
                            size: 16
                        )
                    )
                    .foregroundStyle(textDefault)
            }
            Spacer()
            if cardModel.company_logo != nil {
                Spacer()
                    .frame(width: 8)
                WebImage(
                    url: URL(
                        string: self.cardModel.avatar_url!
                    )
                ) { image in
                        image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: 56,
                            height: 56
                        )
                        .clipped()
                        .cornerRadius(8)
                    } placeholder: {
                            Rectangle().foregroundColor(.gray)
                    }
            }
        }
    }
}
