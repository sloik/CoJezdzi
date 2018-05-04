
import Foundation

import ReSwift

func settingsReducer(action: Action, state: SettingsState?) -> SettingsState {
    var state = state ?? SettingsState(lines: [],
                                       switches: SettingsState.FilterState(tramOnly: false,
                                                                           busOnly: false,
                                                                           lowFloredOnly: false))
    
    return state
}
