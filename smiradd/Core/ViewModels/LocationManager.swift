import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        manager.requestLocation()
    }
    
    func requestLocationWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func checkAuthorization() -> CLAuthorizationStatus {
        return manager.authorizationStatus
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        location = locations.first?.coordinate
        print(location)
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        self.authorizationStatus = status
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
            print("Failed to get user's location: \(error.localizedDescription)")
        }
    
    
}
