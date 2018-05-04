
import MapKit

protocol UserLocationProvider: class {
    var currentUserLocation: CLLocation? { get }
}

class TAnnotation: NSObject, TDataAnnotation {
    fileprivate let tdata: WarsawVehicleDto

    weak var locationProvider: UserLocationProvider? = nil
    
    var type: WarsawVehicleType {
        return tdata.type
    }

    var keyID: String {
        return "l:\(tdata.lines) B:\(tdata.brigade)"
    }

    required init(data:WarsawVehicleDto) {
        tdata = data
        super.init()
    }
}

extension TAnnotation: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: tdata.latitude, longitude: tdata.longitude)
    }
    
    var lines: String {
        return tdata.lines.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var fullLine: String {
        return lines
    }

    var shortTitle: String {
        let title: String = {
            switch tdata.type {
            case .bus:
                return "🚍 \(self.fullLine)"
            case .tram:
                return "🚋 \(self.fullLine)"
            default:
                return self.lines
            }
        }()
        
        return title
    }

    var title: String? {
        return "\(shortTitle)"
    }

    var subtitle: String? {
        if let userLocation = locationProvider?.currentUserLocation {
            let distance = MKMetersBetweenMapPoints(MKMapPointForCoordinate(coordinate), MKMapPointForCoordinate(userLocation.coordinate))
            let rounded = floor(distance)

            let baseMessage = "Odległość: "

            switch rounded < 1000 {
            case true:
                return baseMessage + "\(Int(rounded))" + "m"
            case false:
                let km = rounded / 1000
                return baseMessage + String(format: "%.2f", km) + " km"
            }
        }

        return nil
    }
}

extension TAnnotation {
     override var description: String {
        return tdata.description
    }
}
