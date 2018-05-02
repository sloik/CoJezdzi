import MapKit

protocol TDataAnnotation: class, MKAnnotation {
    var type: WarsawVehicleType { get }
    init(data:WarsawVehicleDto)
}
