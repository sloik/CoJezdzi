import Foundation
import CoreLocation
//import Unbox

enum VehicleType {
    case Bus
    case Tram
    case Unknown
}

struct TData {

    let lat      : Double
    
    let lines    : String
    let fullLines: String?
    
    let brigade  : String
    let lon      : Double
    let time     : String
    
    var type     : VehicleType = .Unknown
    
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

}

//func ==(lhs: TData, rhs: TData) -> Bool {
//   return lhs.hashValue == rhs.hashValue
//}
//
//extension TData: Hashable {
//
//    var hashValue: Int {
//        return fullKeyID.hashValue
//    }
//}


