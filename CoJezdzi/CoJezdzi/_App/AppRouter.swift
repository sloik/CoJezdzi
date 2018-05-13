
import ReSwift
import Rswift

final class AppRouter {
    
    private(set) var currentRoutingDestination: RoutingDestination
    private(set) var currentViewController: UIViewController
    
    var nav: UINavigationController? {
        return currentViewController is UINavigationController ? nil : currentViewController.navigationController
    }
    
    var top: UIViewController {
        return nav?.topViewController ?? currentViewController
    }
    
    init(window: UIWindow) {
        currentViewController = R.storyboard.main.mapScene()!
        currentRoutingDestination = .map
        
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
        
        if nav != nil {
            return navigationControllerFlow(vc: viewController)
        }
        
        
        // check if not visible already
        guard type(of: top) != type(of: viewController) else { return false}

        currentViewController.present(viewController, animated: animated, completion: nil)
        return true
    }
    
    func navigationControllerFlow(vc: UIViewController) -> Bool {

        func containsViewControllerInStack(_ n: UINavigationController) -> Bool {
            return n
                .viewControllers
                .map     (       { type(of: $0)       })
                .contains(where: { $0 == type(of: vc) })
        }
        
        guard let nav = nav, vc is UINavigationController == false, containsViewControllerInStack(nav) == false else { return false}
        
        nav.pushViewController(vc, animated: true)
        return true
    }
}

extension AppRouter: StoreSubscriber {
    
    func newState(state: RoutingState) {
        
        guard state.navigationState != currentRoutingDestination else { return }
        currentRoutingDestination = state.navigationState // update to new state
        
        let shouldAnimate = true
        
        var vc: UIViewController
        
        switch state.navigationState {
        case .map:
            vc = R.storyboard.main.mapScene()!
            
        case .settings:
            vc = R.storyboard.main.settingsScene()!
            
        case .linesFilter:
            vc = R.storyboard.main.linesFilter()!
            
        case .aboutApp:
            vc = R.storyboard.main.aboutApp()!
        }
        
        if show(viewController: vc, animated: shouldAnimate) {
            currentViewController = vc
        }
    }
}
