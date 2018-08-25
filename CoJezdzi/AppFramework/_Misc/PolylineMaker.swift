
import CoreLocation
import MapKit

typealias StringCoordinateDic = [String: CLLocationCoordinate2D]

struct PolylineMaker {
    static func generetePolylines(previousPosytions: StringCoordinateDic, currentPosytions: StringCoordinateDic) -> [String: MKPolyline] {
        var polyModels:[String: MKPolyline] = [:]
        
        for (key, currentValue) in currentPosytions {
            
            // if current is present in previous
            if let prevValue = previousPosytions[key] {
                var arr = [currentValue, prevValue]
                let polyLine = MKPolyline.init(coordinates: &arr, count: 2)
                polyModels[key] = polyLine
            }
        }
        
        return polyModels
    }
}
