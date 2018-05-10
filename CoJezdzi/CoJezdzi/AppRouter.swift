
import ReSwift
import Rswift

final class AppRouter {
    let currentViewController: UIViewController
    
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

fileprivate extension AppRouter {
    func show(viewController: UIViewController, animated: Bool) {
        let newViewControllerType = type(of: viewController)
        
        switch currentViewController {
        case let nav as UINavigationController:
            if type(of: nav.topViewController) == newViewControllerType { return }
            
            nav.pushViewController(viewController, animated: true)
            
        default:
            if type(of: currentViewController) == newViewControllerType { return }
            
            currentViewController.present(viewController, animated: animated, completion: nil)
        }
        
    }
}

extension AppRouter: StoreSubscriber {
    func newState(state: RoutingState) {
        let shouldAnimate = true
        
        var vc: UIViewController
        
        switch state.navigationState {
        case .map:
            vc = R.storyboard.main.mapScene()!
            
        case .settings:
            vc = R.storyboard.main.settingsScene()!
            
        case .linesFilter:
            vc = R.storyboard.main.linesFilter()!
        }
        
        show(viewController: vc, animated: shouldAnimate)
    }
}
