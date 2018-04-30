

import ReSwift

func mapSceneReducer(action: Action, state: MapSceneState?) -> MapSceneState {
    var state: MapSceneState = state ?? MapSceneState(currentTrams: tramsReducer(action: action, state: state?.currentTrams))
    
    state.currentTrams = tramsReducer(action: action, state: state.currentTrams)
    
    return state
}
