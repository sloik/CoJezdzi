

import ReSwift

func mapSceneReducer(action: Action, state: MapSceneState?) -> MapSceneState {
    var state: MapSceneState =
        state ?? MapSceneState(currentTrams: tramsReducer(action: action, state: state?.currentTrams),
                               currentBusses: bussesReducer(action: action, state: state?.currentBusses))
    
    state.currentTrams  = tramsReducer(action: action, state: state.currentTrams)
    state.currentBusses = bussesReducer(action: action, state: state.currentBusses)
    
    return state
}
