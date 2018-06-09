import UIKit

import Colours
import ReSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, Dependable {
    var dependencyContainer: DependencyProvider = DependencyContainer()
    
    var window: UIWindow?
    var grouter: RouterProtocol?
    var persistance: PersistanceProtocol?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { fatalError("Did not create instance of UIWindow!") }

        UINavigationBar.appearance().tintColor = UIColor.eggplant()
        
        grouter = dependencyContainer.makeAppRouter(for: window)
        
        persistance = dependencyContainer.makePersistance()
        persistance?.load()
                
        window.makeKeyAndVisible()

        return true
    }
}
