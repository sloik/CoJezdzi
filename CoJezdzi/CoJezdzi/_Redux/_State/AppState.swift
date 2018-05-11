
import Foundation

import ReSwift

struct AppState: StateType {
    let routingState: RoutingState
    let mapState: MapState
    let settingsState: SettingsState
}
