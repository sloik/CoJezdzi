
import Foundation

import ReSwift

struct AppState: StateType {
    let routingState: RoutingState
    let mapSceneState: MapSceneState
    let settingsSceneState: SettingsState
}
