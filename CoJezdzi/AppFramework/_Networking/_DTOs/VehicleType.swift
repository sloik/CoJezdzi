
import Foundation

enum WarsawVehicleType: String, Codable, Equatable, CaseIterable {    
    case unknown
    case bus
    case tram
}

extension WarsawVehicleType {
    var type: Int {
        switch self {
        case .unknown:
            return 0
        case .bus:
            return 1
        case .tram:
            return 2
        }
    }
}
