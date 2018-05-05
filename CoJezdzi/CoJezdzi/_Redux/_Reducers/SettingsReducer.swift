
import Foundation

import ReSwift

func settingsReducer(action: Action, state: SettingsState?) -> SettingsState {
    var state = state ?? SettingsState(lines: [],
                                       selectedLines: [],
                                       switches: SettingsState.FilterState())
    
    return state
}
