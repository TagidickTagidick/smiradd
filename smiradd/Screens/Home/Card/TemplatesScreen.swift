import SwiftUI

struct TemplatesScreen: View {
    @EnvironmentObject var router: Router
    
    @State private var pageType: PageType = .loading
    
    @EnvironmentObject var cardSettings: CardSettings
    
    @State private var templates: [TemplateModel] = []
    
    @State private var currentIndex: Int = -1
    
    var body: some View {
        ZStack (alignment: .bottom) {
            ScrollView {
                if pageType == .loading {
                    ProgressView()
                }
                else {
                    VStack {
                        CustomAppBar(title: "Шаблоны")
                        Spacer()
                            .frame(height: 16)
                        Text("Выберите шаблон для своей визитки\nТак вашу визитку будут видеть другие люди")
                            .multilineTextAlignment(.center)
                            .font(
                                .custom(
                                    "OpenSans-Medium",
                                    size: 13
                                )
                            )
                            .foregroundStyle(textAdditional)
                        Spacer()
                            .frame(height: 16)
                        ForEach(Array(templates.enumerated()), id: \.offset) {
                            index,
                            templatesModel in
                            VStack {
                                ZStack {
                                    MyCard(
                                        cardModel: CardModel(
                                            id: "",
                                            job_title: "Арт-директор Ozon",
                                            specificity: "",
                                            phone: "7 (920) 121-50-44",
                                            email: "elemochka@klmn.com",
                                            address: nil,
                                            name: "Елена Грибоедова",
                                            useful: nil,
                                            seek: nil,
                                            tg_url: nil,
                                            vk_url: nil,
                                            fb_url: nil,
                                            cv_url: nil,
                                            company_logo: nil,
                                            bio: nil,
                                            bc_template_type: templatesModel.id,
                                            services: nil,
                                            achievements: nil,
                                            avatar_url: nil,
                                            like: false
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                Color(
                                                red: 0.408,
                                                green: 0.784,
                                                blue: 0.58
                                            ),
                                                lineWidth: currentIndex == index ? 4 : 0
                                            )
                                        )
                                    .onTapGesture {
                                        currentIndex = index
                                    }
                                    if currentIndex == index {
                                        ZStack {
                                            Circle()
                                                .fill(Color(
                                                    red: 0.408,
                                                    green: 0.784,
                                                    blue: 0.58
                                                ))
                                                .frame(
                                                    width: 48,
                                                    height: 48
                                                )
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                                Spacer().frame(height: 16)
                            }
                        }
                        Spacer()
                            .frame(height: 74)
                    }
                    .padding(
                        [.horizontal],
                        20
                    )
                }
            }
            SaveButton(canSave: true)
                .offset(y: currentIndex != -1 ? -74 : 0)
                .animation(.spring())
                .transition(.move(edge: .bottom))
                .onTapGesture {
                    cardSettings.bcTemplateType = templates[currentIndex].id
                    router.navigateBack()
                }
        }
        .background(.white)
        .onAppear {
            makeRequest(
                path: "templates",
                method: .get,
                isProd: true
            ) { (result: Result<[TemplateModel], Error>) in
                switch result {
                case .success(let templates):
                    self.templates = templates
                    self.pageType = .matchNotFound
                case .failure(let error):
                    if error.localizedDescription == "The Internet connection appears to be offline." {
                        self.pageType = .noResultsFound
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

extension Animation {
    static func ripple() -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
    }
}
