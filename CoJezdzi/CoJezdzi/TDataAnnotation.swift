import MapKit

protocol TDataAnnotation: class, MKAnnotation {
    var type: VehicleType { get }
    init(data:TData)
}
