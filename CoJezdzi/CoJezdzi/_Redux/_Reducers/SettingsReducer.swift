
import Foundation

import ReSwift

func settingsReducer(action: Action, state: SettingsState?) -> SettingsState {
    switch action {
    case let action as SettingsDidRestoreAction:
        return action.restoredState
        
    default:
        return SettingsState(selectedLines: selectedLinesReducer(action: action,  state: state?.selectedLines),
                                  switches: settingsSwitchReducer(action: action, state: state?.switches))
    }
}

func selectedLinesReducer(action: Action, state: SelectedLinesState?) -> SelectedLinesState {
    let state = state ?? SelectedLinesState(lines: [])
    
    switch action {
    case let action as SelectedLineAddAction:
        return state.add(LineInfo(name: action.line))
        
    case let action as SelectedLineRemoveAction:
        return state.remove(LineInfo(name: action.line))
        
    case _ as SelectedLineRemoveAllAction:
        return SelectedLinesState(lines: [])
        
    default:
        return state
    }
}

func settingsSwitchReducer(action: Action, state: SettingsState.FilterState?) -> SettingsState.FilterState {
    let state =
        state ?? SettingsState.FilterState(tramOnly: .tram(on: false),
                                           busOnly: .bus(on: false),
                                           previousLocations: .previousLocation(on: true))
    
    switch action {
    case let action as SettingsSwitchAction:
        return state.update(action.whitchSwitch)
        
    default:
        return state
    }
}
