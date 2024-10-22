import SwiftUI

class AchievementViewModel: ObservableObject {
    @Published var name: String = ""
    
    @Published var description: String = ""
    
    @Published var url: String = ""
    
    @Published var isAlert: Bool = false
    
    private var commonViewModel: CommonViewModel
    
    init(
        index: Int,
        commonViewModel: CommonViewModel
    ) {
        self.commonViewModel = commonViewModel
        
        if index == -1 {
            return
        }
        
        self.name = self.commonViewModel.achievements[index].name
        self.description = self.commonViewModel.achievements[index].description ?? ""
        self.url = self.commonViewModel.achievements[index].url ?? ""
    }
    
    func openDeleteAlert() {
        self.isAlert = true
    }
}
