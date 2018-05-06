
import ReSwift

struct SettingsState: StateType {
    
    enum Filter {
        case tram(on: Bool)
        case bus(on: Bool)
        case previousLocation(on: Bool)
        
        var isOn: Bool {
            switch self {
            case .tram(let on): return on
            case .bus(let on): return on
            case .previousLocation(let on): return on
            }
        }
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

extension SettingsState {
    func switches(_ inSwitches: FilterState) -> SettingsState {
        return SettingsState(lines: lines, selectedLines: selectedLines, switches: inSwitches)
    }
}

