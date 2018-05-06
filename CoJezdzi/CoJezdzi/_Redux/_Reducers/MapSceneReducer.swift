
import ReSwift

func mapSceneReducer(action: Action, state: MapSceneState?) -> MapSceneState {
    let state: MapSceneState =
        state ?? MapSceneState(currentTrams: VehicleState(data: [], previousData: []),
                               currentBusses: VehicleState(data: [], previousData: []))
    
    return state
        .currentTrams (tramsReducer (action: action, state: state.currentTrams ))
        .currentBusses(bussesReducer(action: action, state: state.currentBusses))
}
