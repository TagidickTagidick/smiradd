import SwiftUI

struct CardEditSpecificityView: View {
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @EnvironmentObject private var viewModel: CardViewModel
    
    var body: some View {
        CustomTextView(
            text: "Отрасль",
            isRequired: true
        )
        Menu {
            ForEach(self.commonViewModel.specificities) {
                specificityModel in
                Button(
                    action: {
                        self.viewModel.specificity = specificityModel.name
                    }
                ) {
                    Text(specificityModel.name)
                }
            }
        } label: {
            HStack {
                Text(self.viewModel.specificity)
                    .font(
                        .custom(
                            "OpenSans-Regular",
                            size: 16
                        )
                    )
                    .foregroundStyle(
                        self.viewModel.specificity == "Выберите отрасль"
                        ? textAdditional
                        : textDefault
                    )
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(textSecondary)
            }
            .padding(
                [.horizontal],
                14
            )
            .padding(
                [.vertical],
                20
            )
            .frame(
                height: 48
            )
            .background(accent50)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        accent100,
                        lineWidth: 1
                    )
            )
        }
    }
}
