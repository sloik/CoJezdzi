import CoreLocation

extension MapScene: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        showCurrentLocationButton?.isHidden = false
        
        switch status {
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .denied:
            showCurrentLocationButton?.isHidden = true
            
        default:
            break
        }
    }
}
