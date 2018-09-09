
import GameplayKit

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
        return "[Node:\(super.description)]: \"\(id)\""
    }
}
