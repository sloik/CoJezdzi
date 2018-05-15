
import GameplayKit

import ReSwift

final class GamePlayAppRouter {
    let graph: GKGraph = {
        
        // defines nodes
        let map =         NF.n(.map)
        let settings =    NF.n(.settings) // this one is emebed in UINavigationController
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
    
    init(window: UIWindow) {
        window.rootViewController = R.storyboard.main.mapScene()!
        
        store.subscribe(self) {
            $0.select {
                $0.routingState
            }
        }
    }
}

extension GamePlayAppRouter: StoreSubscriber {
    
    func newState(state: RoutingState) {
        currentViewController = state.sceneVC
        
        // navigation is required...
        guard let destitnation = state.destination else { return }
        
        
        // TODO:
        // This creates steps that are required to navigate to certain parts of application
        // Finds a paths and creaits pairs of steps that are reqired to navigate.
        // Will have to
//        guard let path = graph.findPath(from: state.scene.node, to: destitnation.node) as? [Node] else { fatalError("woot!") }
//        let navigationSteps = stride(from: 0, to: path.count - 1, by: 1)
//            .map { (path[$0], path[$0+1]) }
        

        switch (state.scene, state.destination) {

        case (_, nil):
            debugPrint("No routing required...")
            
        case (.map, .settings?):
            currentViewController?.present(viewController(for: .settings), animated: true, completion: nil)
            
            
        case (.settings, .linesFilter?):
            currentViewController?.navigationController?.pushViewController(viewController(for: .linesFilter),
                                                                            animated: true)
            
        case (.settings, .aboutApp?):
            currentViewController?.navigationController?.pushViewController(viewController(for: .aboutApp),
                                                                            animated: true)
            
        case (_, _):
            fatalError("Unhandeled case: \((state.scene, state.destination))")
        }
    }
}

extension GamePlayAppRouter {
    func viewController(for destination: RoutingDestination) -> UIViewController {
        var vc: UIViewController? = nil
        
        switch destination {
        case .map:
            vc = R.storyboard.main.mapScene()!
            
        case .settings:
            vc = R.storyboard.main.settingsScene()!
            
        case .linesFilter:
            vc = R.storyboard.main.linesFilter()!
            
        case .aboutApp:
            vc = R.storyboard.main.aboutApp()!
        }
        
        return vc!
    }
}
