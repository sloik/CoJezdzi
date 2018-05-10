
import Foundation

import ReSwift

struct AppState: StateType {
    let routingState: RoutingState
    let mapSceneState: MapState
    let settingsSceneState: SettingsState
}
