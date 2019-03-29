
import Foundation

extension RoutingState {
    public static let mock = RoutingState(scene: .map, destitnation: nil, sceneVC: nil)
}

extension VehicleState {
    public static let mock = VehicleState(data: [], previousData: [])
}

extension MapState {
    public static let mock = MapState(
        showTrafic: false,
        currentTrams: .mock,
        currentBusses: .mock)
}

extension SelectedLinesState {
    public static let mock = SelectedLinesState(lines: [])
}

extension SettingsState.FilterState {
    public static let mock = SettingsState.FilterState(tramOnly: .tram(on: false),
                                                busOnly: .bus(on: false),
                                                previousLocations: .previousLocation(on: true))
}

extension SettingsState {
    public static let mock = SettingsState(selectedLines: .mock,
                                    switches: .mock)
}

extension AppState {
    public static let mock = AppState(routingState: .mock,
                               mapState: .mock,
                               settingsState:.mock )
}
