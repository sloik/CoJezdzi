

import ReSwift

func mapSceneReducer(action: Action, state: MapSceneState?) -> MapSceneState {
    let state: MapSceneState = state ?? MapSceneState(currentTrams: tramsReducer(action: action, state: state?.currentTrams))
    
    return state
}
