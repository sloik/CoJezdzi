
import ReSwift
import Rswift

enum RoutingDestination:String {
    case map = "MapScene"
}

struct RoutingState: StateType {
    let navigationState: RoutingDestination
    
    init(navigationState: RoutingDestination = .map ) {
        self.navigationState = navigationState
    }
}

extension RoutingState {
    func navigationState(_ ns: RoutingDestination) -> RoutingState {
        return RoutingState(navigationState: ns)
    }
}
