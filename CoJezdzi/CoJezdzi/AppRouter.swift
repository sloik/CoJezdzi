
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
        let currentViewControllerType = type(of: currentViewController)
        
        if newViewControllerType == currentViewControllerType {
            return
        }

        currentViewController.present(viewController, animated: animated, completion: nil)
    }
}

extension AppRouter: StoreSubscriber {
    func newState(state: RoutingState) {
        let shouldAnimate = true
        
        var vc:UIViewController
        switch state.navigationState {
        case .map:
            vc = R.storyboard.main.mapScene()!
        }
        
        show(viewController: vc, animated: shouldAnimate)
    }
}
