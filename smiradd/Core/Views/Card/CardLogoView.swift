import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct CardLogoView: View {
    var cardModel: CardModel
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text(self.cardModel.job_title)
                    .font(
                        .custom(
                            "OpenSans-SemiBold",
                            size: 20
                        )
                    )
                    .foregroundStyle(textDefault)
                Spacer()
                    .frame(height: 8)
                Text(self.cardModel.name)
                    .font(
                        .custom(
                            "OpenSans-Medium",
                            size: 16
                        )
                    )
                    .foregroundStyle(textDefault)
            }
            Spacer()
            if self.cardModel.company_logo != nil {
                Spacer()
                    .frame(width: 8)
                WebImage(
                    url: URL(
                        string: self.cardModel.company_logo!
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
                        EmptyView()
                    }
            }
        }
    }
}
