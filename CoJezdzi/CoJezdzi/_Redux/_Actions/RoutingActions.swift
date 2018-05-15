import ReSwift

struct RoutingAction: Action {
    let destination: RoutingDestination
}

struct RoutingSceneAppearsAction: Action {
    let scene: RoutingDestination
    let viewController: UIViewController
}
