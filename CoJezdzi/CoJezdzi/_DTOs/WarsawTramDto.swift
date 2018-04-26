//struct TData: Unboxable {
//
//    let lat      : Double
//
//    let lines    : String
//    let fullLines: String?
//
//    let brigade  : String
//    let lon      : Double
//    let time     : String
//
//    var type     : VehicleType = .Unknown
//
//    init(unboxer: Unboxer) {
//        lon       = try! unboxer.unbox(key: "Lon")
//        lat       = try! unboxer.unbox(key: "Lat")
//
//        let unboxedLines: String     = try! unboxer.unbox(key: "Lines")
//        lines = unboxedLines.trimmingCharacters(in: .whitespacesAndNewlines)
//        fullLines = nil
//
//        time      = try! unboxer.unbox(key: "Time")
//
//        let unboxedBrigade: String   = try! unboxer.unbox(key: "Brigade")
//        brigade = unboxedBrigade.trimmingCharacters(in: .whitespacesAndNewlines)
//    }
//
//}

import Foundation
import CoreLocation

struct WarsawTramDto: Codable {
    let latitude : Double //CLLocationCoordinate2D
    let longitude: Double //CLLocationCoordinate2D
    
    let lines: String
    let fullLines: String?
    
    let brigade: String
    let time: String
    var type: WarsawVehicleType = .unknown
    
    enum CodingKeys: String, CodingKey {
        case latitude = "Lat"
        case longitude = "Lon"
        
        case lines = "Lines"
        case fullLines
        
        case brigade = "Brigade"
        case time = "Time"
//        case type
    }
}
