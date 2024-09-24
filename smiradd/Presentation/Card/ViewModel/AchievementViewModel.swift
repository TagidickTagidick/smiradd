import SwiftUI

class AchievementViewModel: ObservableObject {
    @Published var name: String = ""
    
    @Published var description: String = ""
    
    @Published var url: String = ""
    
    @Published var isAlert: Bool = false
    
    private var cardViewModel: CardViewModel
    
    init(
        index: Int,
        cardViewModel: CardViewModel
    ) {
        self.cardViewModel = cardViewModel
        
        if index == -1 {
            return
        }
        
        self.name = self.cardViewModel.achievements[index].name
        self.description = self.cardViewModel.achievements[index].description ?? ""
        self.url = self.cardViewModel.achievements[index].url ?? ""
    }
    
    func openDeleteAlert() {
        self.isAlert = true
    }
}
