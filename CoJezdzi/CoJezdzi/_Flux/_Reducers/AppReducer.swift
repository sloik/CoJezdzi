
import Foundation

import ReSwift


func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(routingState: routingReducer(action: action, state: state?.routingState),
                    currentTrams:  tramsReducer(action: action, state: state?.currentTrams))
}

