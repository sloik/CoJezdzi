
import Foundation

import ReSwift

func settingsReducer(action: Action, state: SettingsState?) -> SettingsState {
    let state = state ?? SettingsState(lines: [],
                                       selectedLines: [],
                                       switches: settingsSwitchReducer(action: action, state: nil))
    
    return state
        .switches(settingsSwitchReducer(action: action, state: state.switches))
}

func settingsSwitchReducer(action: Action, state: SettingsState.FilterState?) -> SettingsState.FilterState {
    let state =
        state ?? SettingsState.FilterState(tramOnly: .tram(on: false),
                                           busOnly: .bus(on: false),
                                           previousLocations: .previousLocation(on: true))
    
    guard let action = action as? SettingsSwitchAction else {
        return state
    }
    
    return state
        .update(action.whitchSwitch)
}
