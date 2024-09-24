import SwiftUI

struct SplashScreenView: View {
    
    @StateObject var viewModel: SplashScreenViewModel
    
    init(
        commonViewModel: CommonViewModel,
        navigationService: NavigationService,
        locationManager: LocationManager,
        commonRepository: ICommonRepository
    ) {
        _viewModel = StateObject(
            wrappedValue: SplashScreenViewModel(
                commonRepository: commonRepository,
                commonViewModel: commonViewModel,
                navigationService: navigationService,
                locationManager: locationManager
            )
        )
    }
    
    var body: some View {
        Image("logo")
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .background(accent200)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                //self.commonViewModel.getTemplates()
            }
    }
}
