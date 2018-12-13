
//▿ 179 : WarsawTramDto
// {"Lat":52.2352142,"Lon":20.980896,"Time":"2018-05-02 20:03:48","Lines":"24","Brigade":"016"}
//- latitude : 52.255012499999999
//- longitude : 21.030624400000001
//- lines : "20"
//- brigade : "6"
//- time : "2018-05-02 20:03:50"
//- type : CoJezdzi.WarsawVehicleType.unknown

import Foundation
import CoreLocation

struct WarsawVehicleDto: Codable, Equatable {
    let latitude : Double //CLLocationCoordinate2D
    let longitude: Double //CLLocationCoordinate2D
    
    private(set) var lines: String
    
    let brigade: String
    let time: String
    var type: WarsawVehicleType {
        switch lines.count {
        case 1...2: return .tram // trams are from X to XX
        case     3: return .bus  // busses are XXX
            
        default: return .unknown
        }
    }
    
    init(latitude: Double, longitude: Double, lines: String, brigade: String, time: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.lines = lines.trimmingCharacters(in: .whitespacesAndNewlines)
        self.brigade = brigade.trimmingCharacters(in: .whitespacesAndNewlines)
        self.time = time
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case latitude = "Lat"
        case longitude = "Lon"
        
        case lines = "Lines"
        
        case brigade = "Brigade"
        case time = "Time"
    }
}

extension WarsawVehicleDto: CustomStringConvertible {
    var description: String {
        return "<[T] Lines: \(lines)>"
    }
}

extension WarsawVehicleDto: CustomDebugStringConvertible {
    var debugDescription: String {
        return fullKeyID
    }
}

extension WarsawVehicleDto {
    var keyID: String {
        return "Lines:\(lines) Brigade:\(brigade)"
    }
    
    var fullKeyID: String {
        return keyID + " " + "Lon:\(longitude) Lat:\(latitude) Time:\(time)"
    }
    
    var coordinate2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
    }
}
