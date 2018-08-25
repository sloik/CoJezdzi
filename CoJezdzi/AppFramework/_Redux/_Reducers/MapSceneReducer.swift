
import ReSwift
import Overture

func mapSceneReducer(action: Action, state: MapState?) -> MapState {
    let state = mapState(action, state)
    
    return with(
        state,
        concat(
            set(\.currentTrams,  tramsReducer (action: action, state: state.currentTrams )),
            set(\.currentBusses, bussesReducer(action: action, state: state.currentBusses))
        )
    )
}

func mapState(_ action: Action, _ ms: MapState?) -> MapState {
    return ms ?? MapState(currentTrams : tramsReducer (action: action, state: ms?.currentTrams ),
                          currentBusses: bussesReducer(action: action, state: ms?.currentBusses))
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
