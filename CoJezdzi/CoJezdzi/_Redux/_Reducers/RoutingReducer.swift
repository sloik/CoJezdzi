
import ReSwift

func routingReducer(action: Action, state: RoutingState?) -> RoutingState {
    var state: RoutingState = state ?? RoutingState()
    
    switch action {
        
    case let routing as RoutingAction:
        state.navigationState = routing.destination
        
    default: break
    }
    
    return state
}
