
import ReSwift
import Rswift

final class AppRouter {
    private(set) var currentViewController: UIViewController
    
    init(window: UIWindow) {
        currentViewController = R.storyboard.main.mapScene()!
        window.rootViewController = currentViewController
        
        store.subscribe(self) {
            $0.select {
                $0.routingState
            }
        }
    }
}


// TODO: fix app routing xD
fileprivate extension AppRouter {
    func show(viewController: UIViewController, animated: Bool) -> Bool {
        let newViewControllerType = type(of: viewController)
        
        debugPrint("- - - - - -")
        debugPrint("current: \(currentViewController)) new: \(viewController)")
        
        if currentViewController is UINavigationController && viewController is UINavigationController {
            return false
        }
        
        // check if is navigation controller
        if let nav = currentViewController as? UINavigationController {
            // make shure that it's not visible
            guard type(of: nav.topViewController!) != newViewControllerType else { return false }
            nav.pushViewController(viewController, animated: true)
            
            return true
        }
        
        // check if in navigation controller
        if let nav = currentViewController.navigationController {
            
            // make shure that it's not visible
            guard type(of: nav.topViewController!) != newViewControllerType else { return false }
            nav.pushViewController(viewController, animated: true)
            
            return true
        }
        
        
        // check if not visible already
        guard type(of: currentViewController) != newViewControllerType else { return false }
        
        
        currentViewController.present(viewController, animated: animated, completion: nil)
        
        return true
    }
}

extension AppRouter: StoreSubscriber {
    func newState(state: RoutingState) {
        debugPrint(state)
    }
}
