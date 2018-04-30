
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
