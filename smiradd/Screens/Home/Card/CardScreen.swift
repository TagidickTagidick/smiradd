import SwiftUI

struct CardScreen: View {
    @EnvironmentObject var cardSettings: CardSettings
    
    @State var pageType: PageType = .loading
    
    var body: some View {
        ZStack {
            if pageType == .loading {
                ProgressView()
            }
            else {
                if cardSettings.cardType == .editCard || cardSettings.cardType == .newCard {
                    CardEditBody()
                }
                else {
                    CardBody()
                }
            }
        }
        .background(.white)
        .onAppear {
            if cardSettings.cardType == .newCard {
                pageType = .matchNotFound
            }
            else {
                makeRequest(
                    path: "cards/\(cardSettings.cardId)",
                    method: .get
                ) { (result: Result<CardModel, Error>) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let cardModel):
                            self.cardSettings.cardModel = cardModel
                            self.pageType = .matchNotFound
                        case .failure(let error):
                            if error.localizedDescription == "The Internet connection appears to be offline." {
                                self.pageType = .internetError
                            }
                            else {
                                self.pageType = .matchNotFound
                            }
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}
