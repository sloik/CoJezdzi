
import Foundation

import ReSwift

struct SettingsState {
    
    struct FilterState {
        let tramOnly: Bool
        let busOnly: Bool
        let lowFloredOnly: Bool
    }
    
    let lines: Set<String>
    let selectedLines: Set<String>
    let switches: FilterState
    let aboutApp: String = "https://avantapp.wordpress.com/co-jezdzi/"
}
