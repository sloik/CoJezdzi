
import Foundation

import ReSwift


func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(currentTrams:  tramsReducer(action: action, state: state?.currentTrams),
                    previousTrams: tramsReducer(action: action, state: state?.currentTrams))
}

