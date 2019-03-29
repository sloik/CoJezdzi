
import Foundation

import Overture
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
    let state: SelectedLinesState = state ?? SelectedLinesState(lines: [])
    
    switch action {
    case let action as SelectedLineAddAction:
        return with(
            state,
            set(\SelectedLinesState.lines, state.lines.union([LineInfo(name: action.line)]))
        )
        
    case let action as SelectedLineRemoveAction:
        return with(
            state,
            set(\.lines, state.lines.subtracting([LineInfo(name: action.line)]))
        )
        
    case _ as SelectedLineRemoveAllAction:
        return SelectedLinesState(lines: [])
        
    default:
        return state
    }
}

func settingsSwitchReducer(action: Action, state: SettingsState.FilterState?) -> SettingsState.FilterState {
    let state = filterState(state)
    
    switch action {
    case let action as SettingsSwitchAction: return updateSwitches(state, action.whitchSwitch)
        
    default: return state
    }
}

func filterState(_ fs: SettingsState.FilterState?) -> SettingsState.FilterState {
    return fs ?? SettingsState.FilterState(tramOnly: .tram(on: false),
                                              busOnly: .bus(on: false),
                                              previousLocations: .previousLocation(on: true))
}

func updateSwitches(_ state : SettingsState.FilterState,
                    _ filter: SettingsState.Filter) -> SettingsState.FilterState {
    
    switch filter {
    case .tram(let on):
        return with(
            state,
            concat(
                set(\SettingsState.FilterState.tramOnly, .tram(on: on)),
                set(\.busOnly,  .bus(on: on ? false : state.busOnly.isOn))
            )
        )
        
    case .bus(let on):
        return with(
            state,
            concat(
                set(\.busOnly, .bus(on: on)),
                set(\.tramOnly,.tram(on: on ? false : state.tramOnly.isOn))
            )
        )
        
    case .previousLocation(let on):
        return with(
            state,
            set(\.previousLocations, .previousLocation(on: on))
        )
    }
}

