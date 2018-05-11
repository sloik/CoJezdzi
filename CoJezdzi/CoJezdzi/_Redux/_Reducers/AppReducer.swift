
import Foundation

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(routingState: routingReducer(action: action, state: state?.routingState),
                    mapState: mapSceneReducer(action: action, state: state?.mapState),
                    settingsState: settingsReducer(action: action, state: state?.settingsState))
}
