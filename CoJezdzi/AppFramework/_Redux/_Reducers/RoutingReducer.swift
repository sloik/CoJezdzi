
import Overture
import ReSwift

func routingReducer(action: Action, state: RoutingState?) -> RoutingState {
    var state: RoutingState = state ?? RoutingState(scene: .map, destitnation: nil, sceneVC: nil)

    switch action {
        
    case let routing as RoutingAction:
        update(&state, mut(\.destination, routing.destination))

    case let routing as RoutingSceneAppearsAction:
        // we are here no more routing required...
        if let dest = state.destination, dest == routing.scene {
            update(&state, mut(\.destination, nil))
        }
        
        update(
            &state,
            concat(
                mut(\.scene, routing.scene),
                mut(\.sceneVC, routing.viewController)
            )
        )
        
    default: break

    }
    return state
}
