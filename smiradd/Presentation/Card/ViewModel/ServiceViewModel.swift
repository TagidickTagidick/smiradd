import SwiftUI

class ServiceViewModel: ObservableObject {
    @Published var cover: UIImage?
    @Published var coverUrl: String = ""
    
    @Published var name: String = ""
    
    @Published var description: String = ""
    
    @Published var price: String = ""
    
    @Published var isAlert = false
    
    private var cardViewModel: CardViewModel
    
    init(
        index: Int,
        cardViewModel: CardViewModel
    ) {
        self.cardViewModel = cardViewModel
        
        if index == -1 {
            return
        }
        
        self.coverUrl = self.cardViewModel.services[index].cover_url ?? ""
        self.name = self.cardViewModel.services[index].name
        self.description = self.cardViewModel.services[index].description ?? ""
        self.price = String(self.cardViewModel.services[index].price ?? 0)
    }
    
    func onChangePrice() {
        if self.price.count > 3 && self.price.count < 8{
            self.price = self.price.replacingOccurrences(of: " ", with: "")
            let indexToAdd = self.price.index(
                before: self.price.index(
                    self.price.endIndex,
                    offsetBy: -2
                )
            )
            self.price.insert(contentsOf: " ", at: indexToAdd)
        }
    }
    
    func openDeleteAlert() {
        self.isAlert = true
    }
}
