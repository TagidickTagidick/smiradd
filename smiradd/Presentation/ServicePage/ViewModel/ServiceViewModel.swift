import SwiftUI

class ServiceViewModel: ObservableObject {
    @Published var coverImage: UIImage?
    @Published var coverVideo: URL?
    @Published var coverUrl: String = ""
    
    @Published var name: String = ""
    
    @Published var description: String = ""
    
    @Published var price: String = ""
    
    @Published var isAlert = false
    
    private var commonViewModel: CommonViewModel
    
    init(
        index: Int,
        commonViewModel: CommonViewModel
    ) {
        self.commonViewModel = commonViewModel
        
        if index == -1 {
            return
        }
        
        self.coverUrl = self.commonViewModel.services[index].cover_url ?? ""
        self.name = self.commonViewModel.services[index].name
        self.description = self.commonViewModel.services[index].description ?? ""
        self.price = String(self.commonViewModel.services[index].price ?? 0)
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
