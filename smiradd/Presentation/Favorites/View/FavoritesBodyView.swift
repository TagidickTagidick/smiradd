import SwiftUI

struct FavoritesBodyView: View {
    let favorites: [CardModel]
    
    let onDislike: ((String) -> ())
    
    let onTap: ((String) -> ())
    
    @Binding var isAlert: Bool
    let onTapAlert: (() -> ())
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    var body: some View {
        ForEach(
            Array(
                self.favorites.enumerated()
            ),
            id: \.offset
        ) {
            _, cardModel in
            if self.commonViewModel.favoritesSpecificities.contains(cardModel.specificity) || self.commonViewModel.favoritesSpecificities.isEmpty {
                MyCardView(
                    cardModel: cardModel,
                    isMyCard: false,
                    onDislike: {
                        id in
                        self.onDislike(id)
                    }
                )
                    .onTapGesture {
                        self.onTap(cardModel.id)
                    }
                    .customAlert(
                        "Удалить из избранного?",
                        isPresented: self.$isAlert,
                        actionText: "Удалить"
                    ) {
                        self.onTapAlert()
                    } message: {
                        Text("Визитка будет удалена, если у вас нет контактов ее владельца, то вернуть ее можно будет только при личной встрече. Удалить визитку из избранного?")
                    }
                Spacer()
                    .frame(height: 16)
            }
        }
    }
}
