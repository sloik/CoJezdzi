
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
    
    var dependencyContainer: DependencyViewControllers
    
    init(container: DependencyViewControllers, window: UIWindow) {
        dependencyContainer = container
        
        window.rootViewController = dependencyContainer.makeMapSceneViewController()
        
        Current
            .reduxStore
            .subscribe(self) {
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
        
        func extractIds(_ pair:(Node, Node)) -> (RoutingDestination, RoutingDestination) {
            return (pair.0.id, pair.1.id)
        }
        
        func generateNodePairs(_ index: Int) -> (Node, Node) {
            return (path[index], path[index + 1])
        }
        
        func generateSequence<C: Collection>(_ collection: C) -> StrideTo<Int> {
            return stride(from: 0, to: collection.count - 1, by: 1)
        }
        
        return generateSequence(path).map(generateNodePairs >>> extractIds)
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
