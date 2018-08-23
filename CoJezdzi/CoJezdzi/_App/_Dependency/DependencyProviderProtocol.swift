
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

typealias DependencyProvider =
    DependencyViewControllers
    & DependencyRouter
    & DependencyPersistance

struct DependencyContainer {}


extension DependencyContainer: DependencyPersistance {
    func makePersistance() -> PersistanceProtocol {
        return Persistence()
    }
}

extension DependencyContainer: DependencyRouter {
    func makeAppRouter(for window: UIWindow) -> RouterProtocol {
        return GamePlayAppRouter(container: self, window: window)
    }
}

extension DependencyContainer: DependencyViewControllers {
    func makeMapSceneViewController() -> UIViewController {        
        return R.storyboard.main.mapScene()!
    }
    
    func makeSettingsViewController() -> UIViewController {
        return R.storyboard.main.settingsScene()!
    }
    
    func makeLinesFilterViewController() -> UIViewController {
        return R.storyboard.main.linesFilter()!
    }
    
    func makeAboutAppViewController() -> UIViewController {
        return R.storyboard.main.aboutApp()!
    }
}

