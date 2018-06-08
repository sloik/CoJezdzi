
import ReSwift

func mapSceneReducer(action: Action, state: MapState?) -> MapState {
    let state: MapState =
        state ?? MapState(currentTrams: tramsReducer(action: action, state: state?.currentTrams),
                         currentBusses: bussesReducer(action: action, state: state?.currentBusses))
    
    return state
        .currentTrams (tramsReducer (action: action, state: state.currentTrams ))
        .currentBusses(bussesReducer(action: action, state: state.currentBusses))
}

func tramsReducer(action: Action, state: VehicleState?) -> VehicleState {
    var state = state ?? VehicleState(data: [], previousData: [])
    
    switch action {
    case let fetchActions as FetchTramsAction:
        state = VehicleState(data: fetchActions.fetched,
                             previousData: state.data)
        
    default:
        break
    }
    
    return state
}

func bussesReducer(action: Action, state: VehicleState?) -> VehicleState {
    var state = state ?? VehicleState(data: [], previousData: [])
    
    switch action {
    case let fetchActions as FetchBussesAction:
        state = VehicleState(data: fetchActions.fetched,
                             previousData: state.data)
        
    default:
        break
    }
    
    return state
}
