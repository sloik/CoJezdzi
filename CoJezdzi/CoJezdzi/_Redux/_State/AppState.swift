
import Foundation

import ReSwift

struct AppState: StateType, Equatable {
    let routingState: RoutingState
    let mapState: MapState
    let settingsState: SettingsState
}
