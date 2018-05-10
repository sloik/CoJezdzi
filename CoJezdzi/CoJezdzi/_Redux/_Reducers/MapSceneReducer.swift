
import ReSwift

func mapSceneReducer(action: Action, state: MapState?) -> MapState {
    let state: MapState =
        state ?? MapState(currentTrams: VehicleState(data: [], previousData: []),
                               currentBusses: VehicleState(data: [], previousData: []))
    
    return state
        .currentTrams (tramsReducer (action: action, state: state.currentTrams ))
        .currentBusses(bussesReducer(action: action, state: state.currentBusses))
}
