import SwiftUI

struct FilterScreen: View {
    @EnvironmentObject private var router: NavigationService
    @EnvironmentObject private var favoritesSettings: FavoritesSettings
    
    @State private var specificityList: [SpecificityModel] = []
    @State private var currentSpecifities: [SpecificityModel] = []
    @State private var mySpecificities: [String] = []
    
    @State private var find: String = ""
    @FocusState private var findIsFocused: Bool
    
    var body: some View {
        ZStack (alignment: .bottom) {
            VStack (alignment: .leading) {
                HStack {
                    Image(systemName: "arrow.left")
                        .foregroundColor(buttonClick)
                        .onTapGesture {
                            router.navigateBack()
                        }
                    Spacer()
                        .frame(width: 24)
                    Text("Фильтр")
                        .font(
                            .custom(
                                "OpenSans-SemiBold",
                                size: 24
                            )
                        )
                        .foregroundStyle(textDefault)
                    Spacer()
                    if !find.isEmpty {
                        Text("Очистить")
                            .font(
                                .custom(
                                    "OpenSans-SemiBold",
                                    size: 16
                                )
                            )
                            .foregroundStyle(Color(
                                red: 0.898,
                                green: 0.271,
                                blue: 0.267
                            ))
                            .onTapGesture {
                                find = ""
                            }
                    }
                }
                .padding(
                    [.vertical],
                    8
                )
                Spacer()
                    .frame(height: 12)
                CustomTextField(
                    value: $find,
                    hintText: "Найти",
                    focused: $findIsFocused
                )
                .onChange(of: find) {
                    if find.isEmpty {
                        currentSpecifities = specificityList
                    }
                    else {
                        currentSpecifities = []
                        for specificity in specificityList {
                            if specificity.name.contains(find) {
                                currentSpecifities.append(specificity)
                            }
                        }
                    }
                }
                ScrollView (showsIndicators: false) {
                    VStack (alignment: .leading) {
                        ForEach(currentSpecifities) {
                            specificity in
                            HStack {
                                Text(specificity.name)
                                    .font(
                                        .custom(
                                            mySpecificities.contains(specificity.name)
                                            ? "OpenSans-SemiBold"
                                            : "OpenSans-Regular",
                                            size: 16
                                        )
                                    )
                                    .foregroundStyle(textDefault)
                                Spacer()
                                ZStack {
                                    if mySpecificities.contains(specificity.name) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .frame(
                                                width: 10,
                                                height: 8
                                            )
                                    }
                                }
                                .frame(
                                    width: 20,
                                    height: 20
                                )
                                .background(
                                    mySpecificities.contains(specificity.name)
                                    ? Color(
                                        red: 0.408,
                                        green: 0.784,
                                        blue: 0.58
                                    )
                                    : .white
                                )
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(
                                            accent100,
                                            lineWidth: 1
                                        )
                                )
                            }
                            .padding([.vertical], 12)
                            .background(.white)
                            .onTapGesture {
                                if mySpecificities.contains(specificity.name) {
                                    for i in 0..<mySpecificities.count {
                                        if mySpecificities[i] == specificity.name {
                                            mySpecificities.remove(at: i)
                                            break
                                        }
                                    }
                                }
                                else {
                                    mySpecificities.append(specificity.name)
                                }
                            }
                        }
                        Spacer()
                            .frame(height: 142)
                    }
                }
            }
            .padding(
                [.horizontal],
                20
            )
            CustomButton(
                text: "Применить",
                color: textDefault
            )
                .offset(y: mySpecificities == favoritesSettings.mySpecificities ? 0 : -74)
                .animation(.spring())
                .transition(.move(edge: .bottom))
                .onTapGesture {
                    favoritesSettings.mySpecificities = mySpecificities
                    router.navigateBack()
                }
        }
        .background(.white)
            .onAppear {
                makeRequest(path: "specifity", method: .get) { (result: Result<[SpecificityModel], Error>) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let specificityList):
                            self.specificityList = specificityList
                            self.currentSpecifities = specificityList
                            self.mySpecificities = favoritesSettings.mySpecificities
                            //self.pageType = .nothingHere
                        case .failure(let error):
//                            if error.localizedDescription == "The Internet connection appears to be offline." {
//                                self.pageType = .internetError
//                            }
//                            else {
//                                self.pageType = .nothingHere
//                            }
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            .onTapGesture {
                findIsFocused = false
            }
    }
}
