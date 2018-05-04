
import Foundation

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(routingState: routingReducer(action: action, state: state?.routingState),
                    mapSceneState: mapSceneReducer(action: action, state: state?.mapSceneState),
                    settingsSceneState: settingsReducer(action: action, state: state?.settingsSceneState))
}
