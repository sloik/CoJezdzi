
import Foundation

import ReSwift

struct SettingsState {
    
    enum Filters {
        case tram(on: Bool)
        case bus(on: Bool)
        case previousLocation(on: Bool)
    }
    
    struct FilterState {
         let tramOnly          = Filters.tram(on: false)
         let busOnly           = Filters.bus(on: false)
         let previousLocations = Filters.previousLocation(on: true)
    }
    
    let lines: Set<String>
    let selectedLines: Set<String>
    let switches: FilterState
    let aboutApp: String = "https://avantapp.wordpress.com/co-jezdzi/"
}
