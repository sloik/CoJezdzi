
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
        
        var reversed: SettingsState.Filter {
            switch self {
            case .tram(let on): return .tram(on: !on)
            case .bus(let on): return .bus(on: !on)
            case .previousLocation(let on): return .previousLocation(on: !on)
            }
        }
    }
    
    struct FilterState: StateType {
        let tramOnly: Filter
        let busOnly: Filter
        let previousLocations: Filter
    }
    
    let lines: Set<String>
    let selectedLines: SelectedLinesState
    let switches: FilterState
    let aboutApp: String = "https://avantapp.wordpress.com/co-jezdzi/"
}

extension SettingsState {
    func switches(_ inSwitches: FilterState) -> SettingsState {
        return SettingsState(lines: lines, selectedLines: selectedLines, switches: inSwitches)
    }
}

extension SettingsState.FilterState {
    func update(_ inFilter:SettingsState.Filter) -> SettingsState.FilterState {
        switch inFilter {

        case .tram(let isOn):
            return SettingsState.FilterState(tramOnly: inFilter,
                                             busOnly: isOn ? .bus(on: false) : busOnly,
                                             previousLocations: previousLocations)
        case .bus(let isOn):
            return SettingsState.FilterState(tramOnly: isOn ? .tram(on: false) : tramOnly,
                                             busOnly: inFilter,
                                             previousLocations: previousLocations)
        case .previousLocation:
            return SettingsState.FilterState(tramOnly: tramOnly, busOnly: busOnly,  previousLocations: inFilter)
        }
    }
}
