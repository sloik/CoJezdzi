
import ReSwift

struct SettingsState: StateType, Equatable, Codable {
    static func == (lhs: SettingsState, rhs: SettingsState) -> Bool {
        return lhs.switches == rhs.switches
        && lhs.selectedLines == rhs.selectedLines
    }
    
    enum Filter: Equatable, Codable {
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
        
        // MARK: - Codable
        enum CodingKeys: CodingKey {
            case value
            case type
        }
        
        enum EncodedType: String, Codable {
            case tram
            case bus
            case previousLocation
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let isOn = try container.decode(Bool.self, forKey: CodingKeys.value)
            let type = try container.decode(EncodedType.self, forKey: .type)
            
            switch type {
            case .tram:
                self = .tram(on: isOn)
                
            case .bus:
                self = .bus(on: isOn)
                
            case .previousLocation:
                self = .previousLocation(on: isOn)
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            switch self {
            case .tram(let on):
                try container.encode(on, forKey: CodingKeys.value)
                try container.encode(EncodedType.tram, forKey: CodingKeys.type)
                
            case .bus(let on):
                try container.encode(on, forKey: CodingKeys.value)
                try container.encode(EncodedType.bus, forKey: CodingKeys.type)
                
            case .previousLocation(let on):
                try container.encode(on, forKey: CodingKeys.value)
                try container.encode(EncodedType.previousLocation, forKey: CodingKeys.type)
            }
        }
    }
    
    // MARK: -
    struct FilterState: StateType, Equatable, Codable {
        let tramOnly: Filter
        let busOnly: Filter
        let previousLocations: Filter
    }
    
    // MARK: -
    let selectedLines: SelectedLinesState
    let switches: FilterState
    let aboutApp: String = "https://avantapp.wordpress.com/co-jezdzi/"
}

// MARK: -
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
