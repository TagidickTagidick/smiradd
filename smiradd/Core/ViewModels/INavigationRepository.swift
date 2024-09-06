protocol INavigationRepository {
    func navigate(to destination: Destination) {}
    func navigateBack() {}
    func navigateToRoot() {}
}
