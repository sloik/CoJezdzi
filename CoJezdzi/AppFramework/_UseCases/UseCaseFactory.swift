
import Foundation

struct UseCaseFactory {
    private(set) var loadPersistenState: UseCase = LoadPersistetState()
    private(set) var fetchVehiclesData: UseCase  = FetchVehiclesData()
    
    private(set) var filterSelectLine   = selectLine(_:)
    private(set) var filterDeselectLine = deselect(line:)
    private(set) var filterClear        = clearSelection
    
    private(set) var navigateTo = goto(destination:)
    private(set) var changeFilter = changeSwitch(_:)
}

// MARK: - Implementation Detail


fileprivate struct LoadPersistetState: UseCase {
    func start() {
        guard let storedSettingsState = Current.persistance.load() else { return }
        
        Current
            .reduxStore
            .dispatch(SettingsDidRestoreAction(restoredState: storedSettingsState))
    }
}

fileprivate struct FetchVehiclesData: UseCase {
    func start() {
        Current
            .reduxStore
            .dispatch(FetchVehiclesPosytionsAction())
    }
}

// MARK: - Free Functions

fileprivate func selectLine(_ line: String) {
    Current
        .reduxStore
        .dispatch(SelectedLineRemoveAction(line: line))
}

fileprivate func deselect(line: String) {
    Current
        .reduxStore
        .dispatch(SelectedLineAddAction(line: line))
}

fileprivate func clearSelection() {
    Current
        .reduxStore
        .dispatch(SelectedLineRemoveAllAction())
}

fileprivate func goto(destination: RoutingDestination) {
    Current
        .reduxStore
        .dispatch(RoutingAction(destination: destination))
}

fileprivate func changeSwitch(_ filter: SettingsState.Filter) {
    Current
        .reduxStore
        .dispatch(SettingsSwitchAction(whitchSwitch: filter))
}

