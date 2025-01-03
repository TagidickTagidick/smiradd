import SwiftUI
import Combine

struct CustomTextFieldView: View {
    @EnvironmentObject private var viewModel: ProfileViewModel
    
    @Binding var value: String
    var hintText: String
    var focused: FocusState<Bool>.Binding
    var height: CGFloat = 48
    var limit: Int = 100
    var isLongText: Bool = false
    var showCount: Bool = false
    
    func limitText(_ upper: Int) {
            if value.count > upper {
                value = String(value.prefix(upper))
            }
        }
    
    var body: some View {
        ZStack (alignment: .bottomTrailing) {
            TextField(
                "",
                text: $value,
                axis: isLongText ? .vertical : .horizontal
            )
                .focused(focused)
                .onReceive(Just(value)) { _ in limitText(limit) }
                .font(
                    .custom(
                        "OpenSans-Regular",
                        size: 16
                    )
                )
                .foregroundStyle(textDefault)
                .accentColor(.black)
                .placeholder(
                    when: value.isEmpty
                ) {
                    Text(hintText)
                        .foregroundColor(textAdditional)
                }
                .frame(
                    height: height,
                    alignment: isLongText
                    ? .topLeading
                    : .center
                )
                .padding(
                    EdgeInsets(
                    top: height == 48 ? 0 : 16,
                    leading: 20,
                    bottom: height == 48 ? 0 : 16,
                    trailing: 20
                )
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
            if showCount {
                Text("\(value.count)/\(limit)")
                    .font(
                        .custom(
                            "OpenSans-Regular",
                            size: 12
                        )
                    )
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    .padding(
                        [.horizontal],
                        5
                    )
                    .padding(
                        [.vertical],
                        4
                    )
            }
        }
    }
}

