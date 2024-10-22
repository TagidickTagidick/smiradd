import SwiftUI
import PhotosUI

struct SettingsPageView: View {
    @EnvironmentObject private var navigationService: NavigationService
    //@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var viewModel: SettingsViewModel
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    @FocusState private var firstNameIsFocused: Bool
    
    @FocusState private var lastNameIsFocused: Bool
    
    @FocusState private var passwordIsFocused: Bool
    
    @State private var offset: CGFloat = 0
    
    init(
        repository: ISettingsRepository,
        commonRepository: CommonRepository,
        commonViewModel: CommonViewModel,
        navigationService: NavigationService
    ) {
        _viewModel = StateObject(
            wrappedValue: SettingsViewModel(
                repository: repository,
                navigationService: navigationService,
                commonViewModel: commonViewModel,
                commonRepository: commonRepository
            )
        )
    }
    
    var body: some View {
        ZStack (alignment: .top) {
            if self.viewModel.pageType == .loading {
                SettingsLoadingView()
            }
            else {
                SettingsBodyView(
                    firstNameIsFocused: self.$firstNameIsFocused,
                    lastNameIsFocused: self.$lastNameIsFocused,
                    passwordIsFocused: self.$passwordIsFocused
                )
                    .environmentObject(self.viewModel)
            }
            CustomAppBarView(
                title: "Настройки",
                action: {
                    self.navigationService.navigateBack()
                }
            )
            .padding(
                [.horizontal],
                20
            )
            .background(.white)
        }
        .background(.white)
        .onTapGesture {
            self.firstNameIsFocused = false
            self.lastNameIsFocused = false
        }
    }
}
