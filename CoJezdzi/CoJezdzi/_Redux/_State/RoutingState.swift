
import ReSwift
import Rswift

enum RoutingDestination: String {
    case map         = "MapScene"
    case settings    = "SettingsScene"
    case linesFilter = "LinesFilter"
    case aboutApp    = "AboutApp"
}

struct RoutingState: StateType {
    let scene: RoutingDestination
    let destination: RoutingDestination?
    
    weak var sceneVC: UIViewController?
    
    init(scene: RoutingDestination = .map, destitnation: RoutingDestination?, sceneVC: UIViewController? ) {
        self.scene = scene
        self.destination = destitnation
        self.sceneVC = sceneVC
    }
}

extension RoutingState {
    func destitnation(_ inDestination: RoutingDestination?) -> RoutingState {
        return RoutingState(scene: scene, destitnation: inDestination, sceneVC: sceneVC)
    }
    
    func scene(_ inScene: RoutingDestination, _ sceneVC: UIViewController?) -> RoutingState {
        return RoutingState(scene: inScene, destitnation: destination, sceneVC: sceneVC)
    }
}
