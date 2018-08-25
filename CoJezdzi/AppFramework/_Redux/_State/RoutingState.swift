
import ReSwift
import Rswift

enum RoutingDestination: String, Equatable, CaseIterable {
    case map         = "MapScene"
    case settings    = "SettingsScene"
    case linesFilter = "LinesFilter"
    case aboutApp    = "AboutApp"
}

struct RoutingState: StateType {
    private(set) var scene: RoutingDestination
    private(set) var destination: RoutingDestination?
    
    weak private(set) var sceneVC: UIViewController?
    
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
