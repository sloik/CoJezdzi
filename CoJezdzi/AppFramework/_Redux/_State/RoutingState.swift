
import ReSwift
import Rswift

enum RoutingDestination: String, Equatable, CaseIterable {
    case map         = "MapScene"
    case settings    = "SettingsScene"
    case linesFilter = "LinesFilter"
    case aboutApp    = "AboutApp"
}

struct RoutingState: StateType {
    var scene: RoutingDestination
    var destination: RoutingDestination?
    
    var sceneVC: UIViewController?
}

extension RoutingState {
    init(scene: RoutingDestination = .map, destitnation: RoutingDestination?, sceneVC: UIViewController? ) {
        self.scene = scene
        self.destination = destitnation
        self.sceneVC = sceneVC
    }
}

extension RoutingState: Equatable {
    static func == (lhs: RoutingState, rhs: RoutingState) -> Bool {
        return lhs.scene       == rhs.scene
            && lhs.destination == rhs.destination
            && lhs.sceneVC     === rhs.sceneVC
    }
}

extension RoutingState: CustomDebugStringConvertible {
    var debugDescription: String {
        return "[RoutingState]: scene: \(scene), destination: \(String(describing: destination)), vc: \(String(describing: sceneVC))"
    }
}
