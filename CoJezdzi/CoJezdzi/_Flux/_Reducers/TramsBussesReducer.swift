
import ReSwift

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
