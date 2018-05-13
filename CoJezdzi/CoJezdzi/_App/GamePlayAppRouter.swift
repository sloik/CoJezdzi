
import GameplayKit

import ReSwift

protocol Routable {
    var node: Node { get }
}

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
    
    private(set) var currentNode: Node
    
    init(window: UIWindow) {
        window.rootViewController = R.storyboard.main.mapScene()!
        currentNode = Node(id: .map)
        
        store.subscribe(self) {
            $0.select {
                $0.routingState
            }
        }
    }
}

extension GamePlayAppRouter: StoreSubscriber {
    
    func newState(state: RoutingState) {
        
        guard let path = graph.findPath(from: state.navigationState.node, to: currentNode) as? [Node] else {
            fatalError("woot!")
        }
        
        currentNode = state.navigationState.node
        
        debugPrint(path)
        
    }
}

// Node Factory ;)
struct NF {
    static func n(_ destination: RoutingDestination) -> Node {
        struct F {
            static var cache: [RoutingDestination : Node] = [:]
        }
        
        if let cached = F.cache[destination] { return cached }
        
        F.cache[destination] = Node(id: destination)
        
        return F.cache[destination]!
    }
}

class Node: GKGraphNode {
    let id: RoutingDestination
    
    required init(id: RoutingDestination) {
        self.id = id
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var description: String {
        return "Node: \"\(id)\""
    }
}

extension RoutingDestination: Routable {
    var node: Node {
        return NF.n(self)
    }
}
