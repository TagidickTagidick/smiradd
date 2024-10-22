import SwiftUI

struct CardEditSiteView: View {
    @EnvironmentObject private var viewModel: CardViewModel
    
    @FocusState var siteIsFocused: Bool
    
    var body: some View {
        CustomTextView(
            text: "Доп. материалы"
        )
        Spacer()
            .frame(height: 12)
        CustomTextFieldView(
            value: self.$viewModel.site,
            hintText: "Оставьте дополнительную ссылку",
            focused: self.$siteIsFocused
        )
        .onTapGesture {
            self.siteIsFocused = true
        }
    }
}
