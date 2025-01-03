import SwiftUI

struct PageInfoView: View {
    var pageType: PageType
    
    var onTap: () -> Void
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        ZStack {
            if pageType == .loading {
                ProgressView()
            }
            else {
                VStack {
                    Spacer()
                    Image({
                            switch pageType {
                            case .matchNotFound:
                                return "match_not_found"
                            case .noResultsFound:
                                return "no_results_found"
                            case .pageNotFound:
                                return "page_not_found"
                            case .somethingWentWrong:
                                return "something_went_wrong"
                            case .shareLocation:
                                return "share_location"
                            default:
                                return "nothing_here"
                            }
                        }())
                    Spacer()
                        .frame(height: 14)
                    Text({
                        switch pageType {
                        case .matchNotFound:
                            return "Рядом нет активных форумов"
                        case .noResultsFound:
                            return "Нет подключения к интернету"
                        case .pageNotFound:
                            return "На этом форуме больше никого нет"
                        case .somethingWentWrong:
                            return "Упс! Что-то пошло не так..."
                        case .shareLocation:
                            return "Нет доступа к геоданным"
                        default:
                            return "Здесь пока пусто"
                        }
                    }())
                    .multilineTextAlignment(.center)
                        .font(
                            .custom(
                                "OpenSans-Medium",
                                size: 16
                            )
                        )
                        .foregroundStyle(textDefault)
                    Spacer()
                        .frame(height: 14)
                    Text({
                            switch pageType {
                            case .matchNotFound:
                                return "Посетите форум, чтобы увидеть здесь визитки близких по духу людей"
                            case .nothingHereFavorites:
                                return "Сохраняйте визитки, чтобы увидеть их здесь"
                            case .nothingHereNotifications:
                                return "У вас пока нет уведомлений"
                            case .noResultsFound:
                                return "Проверьте подключение к интернету"
                            case .pageNotFound:
                                return "Посещайте больше форумов, чтобы знакомиться с новыми людьми"
                            case .somethingWentWrong:
                                return "Попробуйте перезагрузить приложение"
                            case .shareLocation:
                                return "Для нормальной работы приложения необходимо включить доступ к геоданным"
                            default:
                                return "Попробуйте перезагрузить приложение"
                            }
                        }())
                        .multilineTextAlignment(.center)
                        .font(
                            .custom(
                                "OpenSans-Regular",
                                size: 14
                            )
                        )
                        .foregroundStyle(Color(
                            red: 0.6,
                            green: 0.6,
                            blue: 0.6
                        ))
                    
                    if self.pageType == .matchNotFound || self.pageType == .pageNotFound || self.pageType == .shareLocation {
                        VStack {
                            Spacer()
                                .frame(height: 24)
                            ZStack {
                                Spacer()
                                    .frame(
                                        maxWidth: .infinity,
                                        maxHeight: 56
                                    )
                                    .background(textDefault)
                                    .cornerRadius(28)
                                Text(self.pageType == .matchNotFound || self.pageType == .shareLocation
                                     ? "Войти по коду"
                                     : "Начать сначала")
                                    .font(
                                        .custom(
                                            "OpenSans-SemiBold",
                                            size: 16
                                        )
                                    )
                                    .foregroundStyle(.white)
                            }
                            .onTapGesture {
                                self.onTap()
                            }
                        }
                    }
                    
                    if pageType == .noResultsFound {
                        VStack {
                            Spacer()
                                .frame(height: 36)
                            CustomWhiteButtonView(
                                text: pageType == .noResultsFound ? "Повторить" : "Войти по коду"
                            )
                            .onTapGesture {
                                self.onTap()
                            }
                        }
                    }
                    
                    if pageType == .nothingHereProfile {
                        VStack {
                            Spacer()
                                .frame(height: 36)
                            ZStack {
                                Spacer()
                                    .frame(
                                        maxWidth: .infinity,
                                        maxHeight: 56
                                    )
                                    .background(.white)
                                    .cornerRadius(28)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 28)
                                            .stroke(textDefault)
                                    )
                                Text("Создать визитку")
                                    .font(
                                        .custom(
                                            "OpenSans-SemiBold",
                                            size: 16
                                        )
                                    )
                                    .foregroundStyle(textDefault)
                            }
                            .onTapGesture {
                                self.onTap()
                            }
                        }
                    }
                    Spacer()
                    Spacer()
                }
                .padding(
                    [.horizontal],
                    44
                )
            }
        }
        .frame(
            width: UIScreen.main.bounds.width - 40
            //height: UIScreen.main.bounds.height - 134// - safeAreaInsets.top - safeAreaInsets.bottom
        )
        .background(
            pageType == .loading || pageType == .matchNotFound || pageType == .shareLocation || pageType == .pageNotFound
            ? .white
            : accent50
        )
        .cornerRadius(16)
        .shadow(
            color: pageType == .loading || pageType == .matchNotFound || pageType == .shareLocation || pageType == .pageNotFound
            ? Color(
                red: 0.125,
                green: 0.173,
                blue: 0.275,
                opacity: 0.08
            )
            : accent50,
            radius: pageType == .loading || pageType == .matchNotFound || pageType == .shareLocation || pageType == .pageNotFound
            ? 16
            : 0,
            y: pageType == .loading || pageType == .matchNotFound || pageType == .shareLocation || pageType == .pageNotFound
            ? 4
            : 0
        )
    }
}
