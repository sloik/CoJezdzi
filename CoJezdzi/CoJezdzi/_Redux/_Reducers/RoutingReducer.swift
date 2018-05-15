
import ReSwift

func routingReducer(action: Action, state: RoutingState?) -> RoutingState {
    var state: RoutingState = state ?? RoutingState(scene: .map, destitnation: nil, sceneVC: nil)
    
    switch action {
        
    case let routing as RoutingAction:
        state = RoutingState(scene: state.scene, destitnation: routing.destination, sceneVC: state.sceneVC)
        
    case let routing as RoutingSceneAppearsAction:
        // we are here no more routing required...
        if let dest = state.destination, dest == routing.scene {
            state = state.destitnation(nil)
        }
        
        state = state.scene(routing.scene, routing.viewController)
        
    default: break
    }
    
    return state
}
