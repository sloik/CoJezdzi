
import Foundation

@testable import AppFramework

extension RoutingState {
    static let mock = RoutingState(scene: .map, destitnation: nil, sceneVC: nil)
}

extension VehicleState {
    static let mock = VehicleState(data: [], previousData: [])
}

extension MapState {
    static let mock = MapState(currentTrams: .mock,
                               currentBusses: .mock)
}

extension SelectedLinesState {
    static let mock = SelectedLinesState(lines: [])
}

extension SettingsState.FilterState {
    static let mock = SettingsState.FilterState(tramOnly: .tram(on: false),
                                                busOnly: .bus(on: false),
                                                previousLocations: .previousLocation(on: true))
}

extension SettingsState {
    static let mock = SettingsState(selectedLines: .mock,
                                    switches: .mock)
}

extension AppState {
    static let mock = AppState(routingState: .mock,
                               mapState: .mock,
                               settingsState:.mock )
}
