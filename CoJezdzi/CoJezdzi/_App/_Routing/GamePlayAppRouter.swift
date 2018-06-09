
import GameplayKit

import ReSwift

protocol RouterProtocol {}

final class GamePlayAppRouter: Dependable, RouterProtocol {
    let graph: GKGraph = {
        // defines nodes
        let map =         NF.n(.map)
        let settings =    NF.n(.settings)
        let lineFilters = NF.n(.linesFilter)
        let about =       NF.n(.aboutApp)
        
        // connections
        map.addConnections(to: [settings], bidirectional: true)
        settings.addConnections(to: [lineFilters, about], bidirectional: true)
        
        // create graph
        let graph = GKGraph()
        graph.add([
            map,
                settings,
                    lineFilters,
                    about
            ])
        
        return graph
    }()
    
    private(set) var currentViewController: UIViewController?
    
    var dependencyContainer: (DependencyStore & DependencyViewControllers)
    
    init(container: (DependencyStore & DependencyViewControllers), window: UIWindow) {
        dependencyContainer = container
        
        window.rootViewController = dependencyContainer.makeMapSceneViewController()
        
        dependencyContainer.reduxStore.subscribe(self) {
            $0.select {
                $0.routingState
            }
        }
    }
}

extension GamePlayAppRouter: StoreSubscriber {
    func navigationSteps(from: Node, to: Node) -> [(RoutingDestination, RoutingDestination)] {
        // This creates steps that are required to navigate to certain parts of application
        // Finds a paths and creaits pairs of steps that are reqired to navigate.
        guard let path = graph.findPath(from: from, to: to) as? [Node] else { fatalError("woot!") }
        
        return stride(from: 0, to: path.count - 1, by: 1)
            .map { (path[$0], path[$0+1]) }
            .map { ($0.0.id, $0.1.id) }
    }
    
    func newState(state: RoutingState) {
        currentViewController = state.sceneVC
        
        if let destitnation = state.destination {
            move(steps: navigationSteps(from: state.scene.node, to: destitnation.node))
        }
    }
}

extension GamePlayAppRouter {
    func move(steps: [(RoutingDestination, RoutingDestination)]) {
        guard let (from, to) = steps.first else { return }
        
        switch (from, to) {
        case (.map, .settings):
            currentViewController?
                .present(viewController(for: .settings), animated: true)
            
        case (.settings, .map):
            currentViewController?
                .dismiss(animated: true)
            
        case (.settings, .linesFilter):
            currentViewController?
                .navigationController?
                .pushViewController(viewController(for: .linesFilter),
                                    animated: true)
            
        case (.linesFilter, .settings):
            currentViewController?
                .navigationController?
                .popViewController(animated: true)
            
        case (.settings, .aboutApp):
            currentViewController?
                .navigationController?
                .pushViewController(viewController(for: .aboutApp),
                                    animated: true)
            
        case (.aboutApp, .settings):
            currentViewController?
                .navigationController?
                .popViewController(animated: true)
            
        case (_, _):
            fatalError("Unhandeled case: \((from, to))")
        }
    }
}

extension GamePlayAppRouter {
    func viewController(for destination: RoutingDestination) -> UIViewController {
        var vc: UIViewController? = nil
        
        switch destination {
        case .map:
            vc = dependencyContainer.makeMapSceneViewController()
            
        case .settings:
            vc = dependencyContainer.makeSettingsViewController()
            
        case .linesFilter:
            vc = dependencyContainer.makeLinesFilterViewController()
            
        case .aboutApp:
            vc = dependencyContainer.makeAboutAppViewController()
        }
        
        return vc!
    }
}
