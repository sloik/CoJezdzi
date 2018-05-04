
import ReSwift

func mapSceneReducer(action: Action, state: MapSceneState?) -> MapSceneState {
    var state: MapSceneState =
        state ?? MapSceneState(currentTrams: VehicleState(data: [], previousData: []),
                               currentBusses: VehicleState(data: [], previousData: []))
    
    state = state
        .currentTrams (tramsReducer (action: action, state: state.currentTrams ))
        .currentBusses(bussesReducer(action: action, state: state.currentBusses))
    
    return state
}
