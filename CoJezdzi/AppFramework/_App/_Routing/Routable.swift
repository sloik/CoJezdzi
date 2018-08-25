
import Foundation

protocol Routable {
    var node: Node { get }
}

extension RoutingDestination: Routable {
    var node: Node {
        return NF.n(self)
    }
}
