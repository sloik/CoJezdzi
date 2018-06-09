
import ReSwift
import Rswift

protocol Dependable {
    associatedtype DependableOn
    
    var dependencyContainer: DependableOn { get set }
}

extension Dependable {
    mutating func setContainer(_ container: DependableOn) -> Self {
        dependencyContainer = container
        return self
    }
}

protocol DependencyStore {
    var reduxStore: Store<AppState> { get }
}

protocol DependencyViewControllers {
    func makeMapSceneViewController() -> UIViewController
    func makeSettingsViewController() -> UIViewController
    func makeLinesFilterViewController() -> UIViewController
    func makeAboutAppViewController() -> UIViewController
}

protocol DependencyRouter {
    func makeAppRouter(for: UIWindow) -> RouterProtocol
}

protocol DependencyPersistance {
    func makePersistance() -> PersistanceProtocol
}

typealias DependencyProvider = DependencyStore
    & DependencyViewControllers
    & DependencyRouter
    & DependencyPersistance

struct DependencyContainer: DependencyStore {
    var reduxStore: Store<AppState> {
        struct S {
            static let store = Store<AppState>(reducer: appReducer, state: nil)
        }
        
        return S.store
    }
}

extension DependencyContainer: DependencyPersistance {
    func makePersistance() -> PersistanceProtocol {
        return Persistence(container: self)
    }
}

extension DependencyContainer: DependencyRouter {
    func makeAppRouter(for window: UIWindow) -> RouterProtocol {
        return GamePlayAppRouter(container: self, window: window)
    }
}

extension DependencyContainer: DependencyViewControllers {
    func makeMapSceneViewController() -> UIViewController {        
        var vc = R.storyboard.main.mapScene()!
        return vc.setContainer(self)
    }
    
    func makeSettingsViewController() -> UIViewController {
        let vc = R.storyboard.main.settingsScene()!
        
        let topVC = vc.topViewController as! SettingsVC
        topVC.dependencyContainer = self
        
        return vc
    }
    
    func makeLinesFilterViewController() -> UIViewController {
        var vc = R.storyboard.main.linesFilter()!
        return vc.setContainer(self)
    }
    
    func makeAboutAppViewController() -> UIViewController {
        var vc = R.storyboard.main.aboutApp()!
        return vc.setContainer(self)
    }
}

